Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab0FAFev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:34:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64899 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0FAFet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Uq60NgN88eq7xJN0J9f1PaQqlnNac+iRjCa9RjjRnNBoOeAgdruCVZ2VJ/B9aZhTb0
         u9jepLoBKRrji5W0e18qVXWBqRX5Yd9KIPFMv5XDSWVthAzEiahFX+3iAypktxPkaFX6
         Er7u6n6My9agvDG5K7cZKZydC/1xkta5Dncxw=
Date: Tue, 1 Jun 2010 13:38:42 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] module: make locking more fine-grained.
Message-ID: <20100601053842.GD5134@cr0.nay.redhat.com>
References: <201005252300.07739.rjw@sisk.pl>
 <201005311910.32407.rusty@rustcorp.com.au>
 <201005312130.17038.rusty@rustcorp.com.au>
 <201005312131.43238.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005312131.43238.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 09:31:42PM +0930, Rusty Russell wrote:
>@@ -783,9 +787,13 @@ SYSCALL_DEFINE2(delete_module, const cha
> 	/* Store the name of the last unloaded module for diagnostic purposes */
> 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
> 	ddebug_remove_module(mod->name);
>+
>+	/* free_module doesn't want module_mutex held by caller. */
>+	mutex_unlock(&module_mutex);
> 	free_module(mod);
>-
>- out:
>+	goto out_stop;

As Stephen found in linux-next, this line doesn't pass compiling.
I think this line should be just deleted.

>+
>+out:
> 	mutex_unlock(&module_mutex);
> 	return ret;
> }


Thanks.
