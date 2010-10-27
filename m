Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865Ab0J0PE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:04:26 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:51480 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0J0PEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:04:24 -0400
Message-ID: <4CC83F28.4070802@ge.com>
Date: Wed, 27 Oct 2010 16:03:04 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 09/30] staging/vme: fill in struct device's .release,
 even if it's a NOOP
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-10-git-send-email-cota@braap.org> <4CC804FF.9050908@ge.com> <20101027144642.GP10869@flamenco.cs.columbia.edu>
In-Reply-To: <20101027144642.GP10869@flamenco.cs.columbia.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 15:04:21.0997 (UTC) FILETIME=[3C9CE9D0:01CB75E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/10 15:46, Emilio G. Cota wrote:
> On Wed, Oct 27, 2010 at 11:54:55 +0100, Martyn Welch wrote:
>> On 26/10/10 02:10, Emilio G. Cota wrote:
>>> From: Emilio G. Cota <cota@braap.org>
>>>
>>> Without it we get 32 warnings, one per device being released, when
>>> removing a bridge module.
>>>
>>> After applying this patch, bridge modules can at last be removed
>>> without any apparent hiccup.
>>>
>>> [Note: tested only on the tsi148, it's the only bridge I've got]
>>>
>>
>> I guess this is an artifact of the current lack of refcounting?
> 
> No, that's orthogonal to this. This has to do with the way the
> devices are allocated.
> 
>> This is definitely an issue, however I don't think masking it by adding
>> an empty function is the correct way to go.
> 
> We're not masking anything. The release method is there to free the
> struct it protects when its refcount goes to zero; however, in this
> case the struct wasn't allocated dynamically--the 32 devices are
> stored in struct vme_bridge in an array--and therefore there's
> nothing to do in .release, since struct vme_bridge is freed
> elsewhere.
> 
> While it's true that empty .release methods are usually frowned
> upon (as stated in Documentation/kobject.txt), due to the way
> things are done here it actually makes sense to have an
> empty .release.

Ok, I'm not going to ack this for now as I'd like to discuss
modifications to the approach that is being taken for binding devices
and this patch seems to fall under the scope of this.

Martyn

-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
