Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1CWREr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:04:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54942 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1CWREp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O0XuqB+KDkessmZhgXwpcj/qaiKw/nDbxZcuxiEPx5NKmTKMtc3AFp83arqUUxmXSe
         SlhJ70LQKvrbTS+KhzjJRLI/aJMZZoK/bvARq5Su5ptlnMdeTM6c5ElS3p05j3LLW1y6
         phDuTVZfTK2cOQCvqHdsQvWpgWaue4TtB2vjM=
Date: Wed, 23 Mar 2011 17:59:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
 events regardless of ptrace
Message-ID: <20110323165907.GE12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-8-git-send-email-tj@kernel.org>
 <20110321174306.GA29895@redhat.com>
 <20110322080444.GM12003@htj.dyndns.org>
 <20110322194416.GC28038@redhat.com>
 <20110323091736.GY12003@htj.dyndns.org>
 <20110323092455.GZ12003@htj.dyndns.org>
 <20110323164657.GB22527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323164657.GB22527@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 23, 2011 at 05:46:57PM +0100, Oleg Nesterov wrote:
> > Ooh, on a related note, we probably want to change
> > do_notify_parent_cldstop() too.  tsk->group_leader->real_parent is
> > used as the delivery target when !@for_ptracer.  This is the same with
> > tsk->real_parent and the code has been like this for a long time but
> > is a bit confusing.
> 
> Yes, although in this case we do
> 
> 		tsk = tsk->group_leader;
> 		parent = tsk->real_parent;
> 
> We need to change tsk to report the correct si_pid. But we could do
> 
> 		parent = tsk->real_parent;
> 		tsk = tsk->group_leader;
> 
> not sure this looks less confusing.

They themselves are about the same but the inconsistency with the
is_real_parent() test is a bit confusing, I think.  If we're testing
for duplicates by testing ->real_parent against ->parent then the
actual delivery should be also be using ->real_parent and ->parent,
so...

Thanks.

-- 
tejun
