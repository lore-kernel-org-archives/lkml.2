Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1CKScw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:32:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36740 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1CKScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D5xQVXBX4NZBG9aopl93L9lIKW1GErsVojZ6qPRUt4NeF6818DFEEf+B+2z3kXm5KH
         b03cugx1yXQpgo4F1yy1E4UsfpkwT9sDik84edoHm/BxTHZsZwjfG9DVmOFZhpOCo8TA
         34Auoczk0GLEtl/Pfe8dVVStp+ly4bVLoEZNg=
Date: Fri, 11 Mar 2011 19:29:40 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110311182940.GK13038@htj.dyndns.org>
References: <4D6EB335.8000306@kernel.org>
 <20110303061711.GG28266@mtj.dyndns.org>
 <4D791C9F.1010500@kernel.org>
 <20110311082938.GC13038@htj.dyndns.org>
 <20110311083351.GD13038@htj.dyndns.org>
 <4D7A4430.1030301@kernel.org>
 <20110311155446.GH13038@htj.dyndns.org>
 <AANLkTim31ZDBRtBFL2J5HD8j8__tzkSF_HdD-HVt6V49@mail.gmail.com>
 <20110311181958.GJ13038@htj.dyndns.org>
 <AANLkTimAA-NF43DtrZTHZWLyYMVdDkw89QCLcfsC0Rbh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimAA-NF43DtrZTHZWLyYMVdDkw89QCLcfsC0Rbh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:25:23AM -0800, Yinghai Lu wrote:
> now even emulation have that distance array.
> 
> why keep it simple to make all path have that array?

Okay, I don't know, maybe, but I don't think it's gonna buy much.  We
need boundary check in the distance testing function anyway in case
someone calls in with out-of-bound nid's and not having distance table
is just a degenerate case of the generic sanity check, so there really
isn't much to be gained by allocating dummy table.

-- 
tejun
