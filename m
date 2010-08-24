Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0HXRqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:46:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33238 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0HXRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MCnlrVmD2w0Cs2y4zbKBFCS4dOoj3nRyRm9kqyb8jqNrLEp4/l6duLpZ55u0wghzUR
         Wef6X4SIXAWC2gZaQqweLIRIwdE8vFNinjLoKYYVP4JlbPxwi49zhAHxevqqhRPGo+N1
         pihe879KLGjhnDy6TxwoPgE5JHqogd3pEs9SU=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
	<1277943660-4112-3-git-send-email-x0095840@ti.com>
	<1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
	<1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
Date: Tue, 24 Aug 2010 20:46:23 +0300
Message-ID: <AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 7:31 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>
>
>> -----Original Message-----
>> From: Felipe Contreras [mailto:felipe.contreras@gmail.com]
>> Sent: Tuesday, August 24, 2010 5:09 AM
>> To: Guzman Lugo, Fernando
>> Cc: Kanigeri, Hari; linux-omap@vger.kernel.org;
>> linux-kernel@vger.kernel.org; ohad@wizery.com;
>> hiroshi.doyu@nokia.com; ameya.palande@nokia.com;
>> felipe.contreras@nokia.com
>> Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
>>
>> On Fri, Jul 2, 2010 at 9:39 PM, Guzman Lugo, Fernando
>> <fernando.lugo@ti.com> wrote:
>> > I think, it would be good if we get rid of DMMPOOL size, if
>> the liked list grow up as it is needed, there is no memory
>> penalty of have all the possible iommu addresses valid
>> (11000000 - FFFFFFFF). The reservation will only fail when
>> there is no memory. If a software restriction is needed we
>> could define a start and end addresses for iommu module
>> (maybe as a parameter when the iommu handle for iva2 is got)
>> and that boundaries can be taking in account at the moment of
>> reserve the memory.
>>
>> What happened to this?
>>
>> IIUC what you are proposing is to remove the DMM pool
>> completely, that makes sense to me. However, is it really
>> needed to finish the iommu migration to do this?
>>
>> > I think the reserve/unreserved dspbridge api can disappear
>> and just return the da address in the map function.
>>
>> This is something I've proposed before, so I agree :)
>
> Yeah, that is how it will be. I have been busy with other stuffs, but now
> I have finish a version with all dmm module removed and reserve/unreserve
> Api removed as well. But because a the big # of patches merge in dspbrdge
> I have to rebase them to the latest, I hope finish this week and send
> Them again next week.

Awesome :)

However, I still have the question about the dependency on iommu;
AFAICS the DMM removal doesn't depend on the migration to iommu, which
AFAIK has been stalled for some time.

-- 
Felipe Contreras
