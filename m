Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2CLSE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:04:29 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:45013 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab2CLSEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=fM4vszAIHXf1G2s9VIVQAxLeWW0C0cJx
	tIsRjRtRCaccvE4dL8yMOzJqHlP4+8ER97Ln0yfiLLiYD7pccRaVKN1A5mQK5ugN
	/tIH60GZPCVxIH8SH/ulh8iaEFdWA42u0tAXYrT0+JOLrwz/t5rOSOM/izZP9uIc
	vsJ7TyqlO4Y=
From: Junio C Hamano <gitster@pobox.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Thomas Rast <trast@inf.ethz.ch>, Willy Tarreau <w@1wt.eu>,
        Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        git@vger.kernel.org, Thomas Rast <trast@student.ethz.ch>
Subject: Re: stripping [PATCH] without losing later tags from mailed patches
 (Re: [ 02/12] Remove COMPAT_IA32 support)
References: <20120312002046.041448832@1wt.eu>
 <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com>
 <20120312063027.GB8971@1wt.eu> <20120312064855.GB16820@burratino>
 <20120312085820.GA11569@1wt.eu> <20120312152004.GB9380@kroah.com>
 <20120312152453.GB12405@1wt.eu> <87aa3l4vqq.fsf@thomas.inf.ethz.ch>
 <20120312165703.GB18791@burratino>
Date: Mon, 12 Mar 2012 11:04:23 -0700
In-Reply-To: <20120312165703.GB18791@burratino> (Jonathan Nieder's message of
 "Mon, 12 Mar 2012 11:57:03 -0500")
Message-ID: <7vvcm9snko.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: CD0783EA-6C6D-11E1-AB82-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder <jrnieder@gmail.com> writes:

> Thomas Rast wrote:
>
>> The problem with -b is that it's a backwards-compatibility shorthand for
>> --binary, which used to pass --allow-binary-replacement (or --binary) to
>> git-apply.  However, that option was obsoleted in 2b6eef9 (Make apply
>> --binary a no-op., 2006-09-06) and has been a no-op for over 5 years.
>> It has also not been documented since cb3a160 (git-am: ignore --binary
>> option, 2008-08-09).
>>
>> So perhaps we can safely claim -b for --keep-non-patch, like so:

We can delete "git am -b" (as it was deprecated long time ago), wait
for a cycle or two, and then repurpose it.  I do not mind starting
the first step (delete, but do not say anything about repurposing)
before 1.7.10-rc1 happens.
