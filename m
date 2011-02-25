Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1BYBvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:51:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55595 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab1BYBvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:51:17 -0500
Message-ID: <4D670B07.90005@zytor.com>
Date: Thu, 24 Feb 2011 17:51:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>
Subject: Re: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
References: <20110222201538.15443.81915.stgit@localhost6.localdomain6> <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>
In-Reply-To: <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 05:27 PM, Dan Williams wrote:
> On Tue, Feb 22, 2011 at 12:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> From: Dave Jiang <dave.jiang@intel.com>
>>
>> Moving the probe_roms_32 code to probe_roms and make available for all x86. The
>> end result adapter roms data structure is made available read-only to drivers.
>> The Intel isci SAS driver needs to scan the OROM memory in order to pull OEM
>> parameters from the OROM.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> We could just export adapter_rom_resources directly and be done with it, but
>> it seemed reasonable to have a compile time catch for drivers that try to
>> modify the resources, and that drivers should not assume the number of
>> available adapter roms.
>>
> 
> Ping?  The "RFC" was probably not needed, just wanted clarification if
> the interface for modules to retrieve the adapter rom data was in good
> taste.
> 

Rather than exporting the array -- which is functionally what you're
doing -- I would prefer if the actual probing code can be generalized
and put into probe_roms.c.  Extra bonus if it can be unified with the
existing probing code.

	-hpa
