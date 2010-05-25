Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0EYOKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:10:34 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:60670 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab0EYOKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FhaopR6JirnCr/fm760ShbvCCUAquUNempOIkpWRTfYeAd9pJpTg2qJrkG4pdV3see
         bjyXSUfW1s/4KQ1ai2++aSHMNOs6etXtr+4hu66gPP2tZ1A3U+JyzJ9xx0lDuoWzCZPt
         pfe4zAZ1CVUhW9PItvg8Try+vd+f5j0d0dpxM=
MIME-Version: 1.0
In-Reply-To: <20100525140240.GG9731@ics.muni.cz>
References: <20100507153920.GP28167@ics.muni.cz>
	 <AANLkTimsQTYWndbQo2nU01pcJfTRSZlPCMEY8m-CnksM@mail.gmail.com>
	 <20100525140240.GG9731@ics.muni.cz>
Date: Tue, 25 May 2010 10:10:28 -0400
Message-ID: <AANLkTimfHrXViu0Zm75i4cFED7pXqAvv2edmKRpIi4me@mail.gmail.com>
Subject: Re: Deadlock in NFSv4 in all kernels
From: "William A. (Andy) Adamson" <androsadamson@gmail.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, salvet@ics.muni.cz
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/25 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> On Tue, May 25, 2010 at 09:45:32AM -0400, William A. (Andy) Adamson wrote:
>> Not get into the problem in the first place: this means
>>
>> 1) determine a 'lead time' where the NFS client declares a context
>> expired even though it really as 'lead time' until it actually
>> expires.
>>
>> 2) flush all writes on any contex that will expire within the lead
>> time which needs to be long enough for flushes to take place.
>
> I think you cannot give any guarantees that the flush happens on time. There
> can be server overload, network overload, anything and you are out of luck.

True - but this will be the case no matter what scheme is in place.
The above is to handle the normal working situation. When this fails
due to network, server overload, server reboot, i.e. not-normal
situation, then use the machine credential.

-->Andy

>
> --
> Luká¹ Hejtmánek
>
