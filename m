Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1BZKz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 05:55:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49314 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1BZKzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 05:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AH8IE1LtW4yJC5koVeMKzv3+CJ4gyQYrOeaZODQpssfiOb7KveJ6nmIRIiQ7Ue1z23
         WRqPIPTC91uHC9HeMhkNkXvoUa9hOIhHIWAA3Cpkir0Y+MXZCvF1NOtzamb0FRF3gqdU
         F7DBREjErvoSR3QM8ob6UKE6BYuBiIRPYZeJs=
Date: Sat, 26 Feb 2011 11:55:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86,mm,64bit: Round up memory boundary for
 init_memory_mapping_high()
Message-ID: <20110226105520.GA9700@htj.dyndns.org>
References: <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
 <20110224091557.GD7840@htj.dyndns.org>
 <4D674A33.8000809@kernel.org>
 <20110225100336.GA26608@elte.hu>
 <4D686EB8.4080507@kernel.org>
 <20110226103616.GA8701@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226103616.GA8701@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 11:36:16AM +0100, Tejun Heo wrote:
> On Fri, Feb 25, 2011 at 07:08:40PM -0800, Yinghai Lu wrote:
> > +	end_pfn = round_up(end_pfn, data->align>>PAGE_SHIFT);
> 
> And now you're mapping beyond max_pfn without even noting the behavior
> change _anywhere_.  What the hell?  It's not like this point hasn't
> been brought up before.  It has been mentioned _twice_ in this very
> thread.  Come on.

Reading the code again, the range is capped by
mapping_work_data->start/end, so it won't go over max_pfn.  I
apologize for the unwarranted rant about this part, but unfortunately
the rest of the complaints still stand.

Thanks.

-- 
tejun
