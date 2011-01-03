Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1ACPUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:20:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40975 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1ACPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bzQQTXt7ZFy7qbKShgxeimNQVnG7fESU11bQHBfQcM0EBZG0kx/4DyyF1qRf+uKEcY
         P0/5lR0UCAOeEF8BBvJGndnp8Jr7fDKmdXUILBDkTOecVBHhW7Fbe9Nj/ysYgUkct784
         qQ+UsrzndnSmEnu7tUJbxQaH6DDfk0G71Zrgs=
Date: Mon, 3 Jan 2011 16:20:17 +0100
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED] workqueue: relax lockdep annotation on
 flush_work()
Message-ID: <20110103152017.GV18831@htj.dyndns.org>
References: <20101229125711.GL488@htj.dyndns.org>
 <1294047091.2016.38.camel@laptop>
 <20110103141735.GQ18831@htj.dyndns.org>
 <1294066490.2016.81.camel@laptop>
 <20110103150052.GU18831@htj.dyndns.org>
 <1294067685.2016.83.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294067685.2016.83.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 04:14:45PM +0100, Peter Zijlstra wrote:
> > Hmmm?  The code applies the most strict contraints.  If the workqueue
> > has a rescuer, flushing another work from the workqueue will always
> > trigger lockdep warning.  The rule is relaxed only for workqueues
> > which aren't used for memory reclaiming && support parallel execution.
> 
> Ah, ok. I read it like: if the current thread is a rescue thread.

Ah, I see.  Rafael, can you please verify the updated version is okay
too (it should be but just in case)?  Peter, shall I route this
through workqueue tree with your ack?

Thank you.

-- 
tejun
