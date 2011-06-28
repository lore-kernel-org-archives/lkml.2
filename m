Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1F1IZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:25:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36035 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1F1IZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OEnA0jTiIk5WWMJmrhLtUcMaAiX5tfLvTHMV34/VZsCj5MZJ8xtyjOBq6N1AnRNOmy
         ndzdNLgvkRTPfIWI4qsXncs3cMyEKPt9Fxa427ny7r/q5fICV7cjuC6/vrnjKWUP6dyA
         lPowgCs5wEtRo7WkST3PR6uC3u7b12kHiek40=
Date: Tue, 28 Jun 2011 10:25:12 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110628082512.GA3386@htj.dyndns.org>
References: <201106262108.43011.vda.linux@googlemail.com>
 <20110626200442.GA16293@redhat.com>
 <20110627081139.GY30101@htj.dyndns.org>
 <20110627134713.GB3527@redhat.com>
 <20110627135252.GB30101@htj.dyndns.org>
 <20110627151827.GA6223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627151827.GA6223@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 27, 2011 at 05:18:27PM +0200, Oleg Nesterov wrote:
> > and the only way to discover would be either comparing kernel
> > version or actually trying it - both aren't too nice.
> 
> Fortunately, currently tracehook_report_exec() zeroes ->ptrace_message.
> At least this means that anything != 0 means it works.

Yeah, but that's a pretty silly way to do it.  If we make it depend on
PT_SEIZED, we can simply say "if seized, EXEC reports..." but as it
currently stands, it would go like "If the message is non-zero on
EXEC, it indicates...  This behavior is valid since kernel version
x.x.x".  Maybe adding a guarantee that PTRACE_SEIZE capable kernel
always reports the old pid on EXEC but that would still seem
unnecessarily complicated.  It isn't a bug fix.  I don't see much
point in introducing new behavior separately.

Thanks.

-- 
tejun
