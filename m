Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2KTHWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:22:24 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39528 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426Ab2KTHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:22:23 -0500
Message-ID: <50AB26D2.5090602@vmware.com>
Date: Tue, 20 Nov 2012 07:44:34 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drm/ttm, drm/vmwgfx: Use RCU locking for object lookups
 v3
References: <1352201511-6383-1-git-send-email-thellstrom@vmware.com> <1352201511-6383-4-git-send-email-thellstrom@vmware.com> <CAPM=9txb2aQ6zXYKdxDiuL0jOBA9epM_kBT8zeOOcUDN42gQ_w@mail.gmail.com>
In-Reply-To: <CAPM=9txb2aQ6zXYKdxDiuL0jOBA9epM_kBT8zeOOcUDN42gQ_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 07:19 AM, Dave Airlie wrote:
> On Tue, Nov 6, 2012 at 9:31 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> The mostly used lookup+get put+potential_destroy path of TTM objects
>> is converted to use RCU locks. This will substantially decrease the amount
>> of locked bus cycles during normal operation.
>> Since we use kfree_rcu to free the objects, no rcu synchronization is needed
>> at module unload time.
> As this is the first use of RCU in a drm driver from what I can see,
> let me remind that the
> RCU patent agreement AFAIK only covers GPL works.
>
> So non-GPL or other OSes porting this code should take not of this.
>
> Dave.

 From VMware's side this won't be a problem, since other VMware kernel 
modules (VMCI IIRC) use RCU.

In any case I have a new version of the "vmwgfx optimization" patch 
series that mostly add documentation and
annotation (by  using a drm_ht_xxx_rcu) interface for hashtab, after an 
internal review by Dmitry Torkov. I see you've already
applied the original patch series. Do you want me to send out the new 
one or rebase it against current drm-next?

Thanks,
Thomas

