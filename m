Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031507Ab2COBo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031223Ab2COBoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:44:25 -0400
Message-ID: <4F61496D.8030000@redhat.com>
Date: Wed, 14 Mar 2012 22:44:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com> <4F60F2E4.7060707@redhat.com> <20120314204355.GA10187@kroah.com> <20120314223102.GA27602@aftab>
In-Reply-To: <20120314223102.GA27602@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 14-03-2012 19:31, Borislav Petkov escreveu:
> On Wed, Mar 14, 2012 at 01:43:55PM -0700, Greg KH wrote:
>>> He thinks that a multi-layer struct should be created inside that directory
>>> (it could have 2 or 3 levels of directories, depending on how the memory is
>>> organized at the memory controller), instead of having a large number of files
>>> there.
>>
>> Why create subdirs?  If those subdirectories are not real devices,
>> showing a real hierarchy, then do not create them as userspace will get
>> very confused very quickly.
> 
> Why, IMO, we agreed on the following layout
> 
> rank0/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> |-- CE
> |-- UE
> `-- dimm_size
> 
> with CE being the correctable errors counter and UE be optional and only
> present when it makes sense for the hardware.

As I said, that is easy to implement. The hard part would be what to do with
the per-csrow/per-branch error counters that exist currently at EDAC.

>From my side, I'm OK to remove them, but, as I said before, existing user tools
use them, especially because UE errors aren't per-rank/per-dimm on the
typical case (128 bits cacheline).

Of course, the EDAC logic could increment multiple UE error counters in such
case, (meaning that an error happened on either one of the affected DIMMs/Ranks)
but this is a different behavior than the current API.

Regards,
Mauro
