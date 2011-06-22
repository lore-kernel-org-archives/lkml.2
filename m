Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1FVGyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:54:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46204 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1FVGyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mvo6LewAGw59BG0mZ1D1adpyrNbT30DuMpm3LeLUFA/RRKIrJHM/wdrpssyaI076qR
         /hpjbuPl6wdrQTrgJqyNDZEQ6qOouVDN2l8sh62VzCP2oay1+JsBvXttbn4kAlNWEa6L
         cU1Df1vET0BARqrQeTnp9n4HfNdAZa2MXVPyc=
Date: Wed, 22 Jun 2011 10:54:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v2] taskstats: don't allow duplicate entries in
 listener mode
Message-ID: <20110622065406.GA4011@albatros>
References: <1308239759-4797-1-git-send-email-segoon@openwall.com>
 <20110621154900.ea6b8839.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621154900.ea6b8839.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 15:49 -0700, Andrew Morton wrote:
> On Thu, 16 Jun 2011 19:55:59 +0400
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
> > Currently a single process may register exit handlers unlimited times.
> > It may lead to a bloated listeners chain and very slow process terminations.
> > E.g. after 10KK sent TASKSTATS_CMD_ATTR_REGISTER_CPUMASKs ~300 Mb of
> > kernel memory is stolen for the handlers chain and "time id" shows 2-7
> > seconds instead of normal 0.003.  It makes it possible to exhaust all
> > kernel memory and to eat much of CPU time by triggerring numerous exits
> > on a single CPU.
> > 
> > The patch limits the number of times a single process may register
> > itself on a single CPU to one.
> > 
> > One little issue is kept unfixed - as taskstats_exit() is called before
> > exit_files() in do_exit(), the orphaned listener entry (if it was not
> > explicitly deregistered) is kept until the next someone's exit() and
> > implicit deregistration in send_cpu_listeners().  So, if a process
> > registered itself as a listener exits and the next spawned process gets
> > the same pid, it would inherit taskstats attributes.
> 
> ow. That's an unprivileged operation, isn't it?

Yes.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
