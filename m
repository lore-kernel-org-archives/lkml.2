Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab0E0OyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:54:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60448 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab0E0OyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W2dpTfhqKF73FjnHOeEpxX+6717k6yZc/L+9rTUV90LGLF5JnpAcmvNKPGK/YmyjsL
         RQkrKaojEPp7c9BFpd0O1CBxml5bmbn65O8VeLpyhdK9Kh8PcoZvzFoIQHFsCNSIkwLY
         JriMEuhsBFbVjEnLngq5ZztYN785oE/+U1XAo=
Date: Thu, 27 May 2010 22:59:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>, davem@davemloft.net,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org, torvalds@osdl.org,
       viro@ZenIV.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
Message-ID: <20100527145807.GB3600@hack>
References: <25328.1274886067@redhat.com> <4BFE4203.5010803@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFE4203.5010803@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:57:23AM +0200, Tejun Heo wrote:
>Commit fa4b9074cd8428958c2adf9dc0c831f46e27c193 made s_umount depend
>on keventd; however, emergency remount schedules works to keventd
>which grabs s_umount creating a circular dependency.  Run emergency
>remount on a separate workqueue to break it.
>


I have a stupid question, why using workqueue instead of
calling do_remount_sb() directly in emergency_remount()?
Avoid blocking emergency_remount()?

Thanks.

-- 
Live like a child, think like the god.
 
