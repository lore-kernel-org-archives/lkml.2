Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1HEJZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:25:00 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:34813 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1HEJY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:24:59 -0400
Message-ID: <4E3BB6E7.6020809@ge.com>
Date: Fri, 05 Aug 2011 10:24:55 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch> <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch> <4E39555C.30507@ge.com> <20110803140630.GA29460@becoht-mvanga> <20110803152317.GA21903@flamenco.cs.columbia.edu> <4E3A4904.3040007@ge.com> <20110804163451.GA18422@flamenco.cs.columbia.edu> <4E3B9FA2.3060303@ge.com> <20110805090416.GA4806@becoht-mvanga>
In-Reply-To: <20110805090416.GA4806@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Aug 2011 09:21:45.0159 (UTC) FILETIME=[1845DD70:01CC5351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/11 10:04, Manohar Vanga wrote:
> Hey Martin,
> 
>> Actually, it would give you a good indication of how many of the resources
>> provided by each VME bridge chip were used. I don't see the refcount
>> accurately reflecting the number of users as being important, more as a means
>> of tracking which bridges have resources that are being used (and therefore
>> can't be removed).
> 
> On second thought, I think I agree with Emilio that the _module_ refcount should
> reflect the number of users (other modules) using the bridge module. The refcount
> of resources should probably stay separate from the refcount of module usage. We
> can add resource refcounting as well but I don't see a need for it at the moment.
> 
> vme_bridge_get() and vme_bridge_put() in this case should refer to the reference
> count of the bridge module (not the resources). What do you think?
> 

I think that by refcounting the resources being used we will know whether a
bridge module is being used or not, thus whether it can be unloaded or not. By
reference counting the use of resources we minimise the chance of poorly
written drivers using resources, but not registering the fact that they are in
fact using a VME bridge.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
