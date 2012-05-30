Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2E3S32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:29:28 -0400
Received: from mga10.intel.com ([192.55.52.92]:19576 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756246Ab2E3S30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120530182239.GD15635@x1.osrc.amd.com>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
	<20120530182239.GD15635@x1.osrc.amd.com>
Date: Wed, 30 May 2012 11:29:23 -0700
Message-ID: <CABE8wwsw98KZS0W1sJghzrei0mSGLiMoh+7Wn5xOzdM54qiYqA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
From: Dan Williams <dan.j.williams@intel.com>
To: Borislav Petkov <bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mroos@linux.ee, JBottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:22 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 30, 2012 at 11:21:25AM -0700, Dan Williams wrote:
>> Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domain"
>> introduces a boot regression by moving sd probe work off of the global
>> async queue.  Using a local async domain hides the probe work from being
>> synchronized by wait_for_device_probe()->async_synchronize_full().
>>
>> Fix this by teaching async_synchronize_full() to flush all async work
>> regardless of domain, and take the opportunity to convert scsi scanning
>> to async_schedule().  This enables wait_for_device_probe() to flush scsi
>> scanning work.
>
> Looks like those fix a similar boot issue I reported earlier:
>
> http://marc.info/?l=linux-kernel&m=133839683405526&w=2
>
> Should I give them a run or are they still in review?
>

They're ready for a run, but are likely 3.6 material.  For 3.5 I think
James is going with the smaller fix posted here:

http://marc.info/?l=linux-scsi&m=133796775807498&w=2

--
Dan
