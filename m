Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2KTH77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:59:59 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50112 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:59:58 -0500
MIME-Version: 1.0
In-Reply-To: <50AB26D2.5090602@vmware.com>
References: <1352201511-6383-1-git-send-email-thellstrom@vmware.com>
	<1352201511-6383-4-git-send-email-thellstrom@vmware.com>
	<CAPM=9txb2aQ6zXYKdxDiuL0jOBA9epM_kBT8zeOOcUDN42gQ_w@mail.gmail.com>
	<50AB26D2.5090602@vmware.com>
Date: Tue, 20 Nov 2012 17:59:57 +1000
Message-ID: <CAPM=9txL2TH3rPY7UO5KWEHcqbcdzEF3cPV3jBE1c1b=v++2+w@mail.gmail.com>
Subject: Re: [PATCH 3/4] drm/ttm, drm/vmwgfx: Use RCU locking for object
 lookups v3
From: Dave Airlie <airlied@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 4:44 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> On 11/20/2012 07:19 AM, Dave Airlie wrote:
>>
>> On Tue, Nov 6, 2012 at 9:31 PM, Thomas Hellstrom <thellstrom@vmware.com>
>> wrote:
>>>
>>> The mostly used lookup+get put+potential_destroy path of TTM objects
>>> is converted to use RCU locks. This will substantially decrease the
>>> amount
>>> of locked bus cycles during normal operation.
>>> Since we use kfree_rcu to free the objects, no rcu synchronization is
>>> needed
>>> at module unload time.
>>
>> As this is the first use of RCU in a drm driver from what I can see,
>> let me remind that the
>> RCU patent agreement AFAIK only covers GPL works.
>>
>> So non-GPL or other OSes porting this code should take not of this.
>>
>> Dave.
>
>
> From VMware's side this won't be a problem, since other VMware kernel
> modules (VMCI IIRC) use RCU.
>
> In any case I have a new version of the "vmwgfx optimization" patch series
> that mostly add documentation and
> annotation (by  using a drm_ht_xxx_rcu) interface for hashtab, after an
> internal review by Dmitry Torkov. I see you've already
> applied the original patch series. Do you want me to send out the new one or
> rebase it against current drm-next?

Can you rebase it on top of -next?

Dave.
