Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1DFNJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:09:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52772 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab1DFNJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SoOJdcTnHt6zd2w8D2uPrqoeeHmHzR6OO0iyBjMLTHQ0hnZD0YNzgRVIMhIwSNAgmD
         LZe1ZPqcBmALaxmCX5NXddQqaoD+1SK1vmVfqIDgkPG6idQpYEI2uR1Vw08KJxEoHSrP
         lpH/jMXHuXe+QXqqu2fkFKBhhqRJrxREKkQsk=
Date: Wed, 6 Apr 2011 06:09:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
 'shared_pending'
Message-ID: <20110406130928.GF4142@mtj.dyndns.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
 <1302031310-1765-2-git-send-email-matt@console-pimps.org>
 <20110405201958.GA1404@redhat.com>
 <20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
 <20110406125757.GA12099@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406125757.GA12099@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Wed, Apr 06, 2011 at 02:57:57PM +0200, Oleg Nesterov wrote:
> But even SIGSTOP should be routed properly. If the process is ptraced,
> the tracee reports SIGSTOP to the debugger first. This means that
> tkill(SIGSTOP) should be delivered to the right target.

I think the more important part is that there really isn't much point
in optimizing SIGSTOP/CONT.  They inherently involve heavy,
walk-every-thread operations of putting them to sleep and reversing it
and there isn't much point in optimizing sending SIGSTOP to stopped
processes or CONT to running ones.  In addition, STOP/CONT interaction
is already scary enough so I'd like to avoid adding complexities there
if at all possible.

I think it would be better to concentrate on more usual signals.

Thank you.

-- 
tejun
