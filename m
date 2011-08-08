Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1HHJmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:42:44 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:49264 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1HHJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:42:43 -0400
Message-ID: <4E3FAF8F.9060106@ge.com>
Date: Mon, 08 Aug 2011 10:42:39 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga> <4E3BB6E7.6020809@ge.com> <20110805174728.GA1741@flamenco.cs.columbia.edu> <4E3F97EA.2020600@ge.com> <20110808091432.GA19570@flamenco.cs.columbia.edu>
In-Reply-To: <20110808091432.GA19570@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2011 09:42:40.0966 (UTC) FILETIME=[84080E60:01CC55AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/11 10:14, Emilio G. Cota wrote:
> On Mon, Aug 08, 2011 at 09:01:46 +0100, Martyn Welch wrote:
>> On 05/08/11 18:47, Emilio G. Cota wrote:
>>> A driver leaking a resource will then leave a bogus refcount
>>> Refcounting must be kept simple & stupid; doing it behind the
>>> backs of the drivers we're trying to protect is a mistake.
>>
>> I just simply disagree. Forcing each driver to specifically maintain the
>> refcount is just stupid when an alternative is possible.
> 
> Martyn, no one in the kernel is doing what you propose, for
> good reason. Look at USB, PCI, RapidIO.  They all provide get
> and put functions to be called from probe and release.
> 

Really, which functions are these for PCI?

> Doing otherwise is a bug. If a driver needs a resource *not
> necessarily at .probe time*, it increments the refcount
> then (in .probe) to make sure that the parent driver won't
> be removed. IOW if you increase the refcount in the bridge
> driver only when a resource is requested you're doomed,
> because when the non-probe request arrives, the bridge driver
> may have been removed already.. And the kernel gently reminds
> you of this fact in the form of an oops.
> 

The probe is going to need to request the resources to access the hardware it
is designed to control. Hence it will be incrementing the refcount exactly
when it needs to.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
