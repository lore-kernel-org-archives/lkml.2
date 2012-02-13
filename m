Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2BMPNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:13:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2BMPNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:13:01 -0500
Message-ID: <4F39287A.9030808@suse.de>
Date: Mon, 13 Feb 2012 16:12:58 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, Dor Laor <dlaor@redhat.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Hoff <christian.hoff@de.ibm.com>,
        borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
References: <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com> <4F38B657.7060405@de.ibm.com> <4F38C27E.7030300@redhat.com> <1329136806.9333.383.camel@haakon2.linux-iscsi.org> <4F3907EB.4030402@redhat.com> <20120213130005.GB26773@redhat.com> <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com> <20120213131848.GD26773@redhat.com>
In-Reply-To: <20120213131848.GD26773@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 02:18 PM, Michael S. Tsirkin wrote:
> On Tue, Feb 14, 2012 at 12:13:36AM +1100, ronnie sahlberg wrote:
>> On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>>> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
>>>> Only if you use the pci multi-function option but that kills
>>>> standard hot unplug
>>>
>>> It doesn't kill it as such, rather you can't unplug luns individually.
>>
>> Isnt that just a consequence of the current implementation rather than
>> a SCSI limitation?
> 
> Yes.
> 
>> A different way to do hoplug could be to flag all devices as removable
>> in the standard inq page then
>> leave the LUN there persistently and what you remove/add is not the
>> LUN device itself but just the media in the device.
>>
>> Instead of hot-plug remove the LUN,  hot-plug becomes "media eject" or
>> "media insert".
>> The device remains present all time, you never remove it, but instead
>> hot-plug controls if the media is present or not.
>>
>>
>> This would require implementing at least START_STOP_UNIT and
>> PREVENT_ALLOW_MEDIUM_REMOVAL opcode emulation from SBC.
>>
>>
>> regards
>> ronnie sahlberg
> 
> That would work.
>
Or we simply use the Peripheral Qualifier that the device is gone;
eg we could simply set PQ = 1, return sense code 0x25/00 and be done
with ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
