Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2E3VtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:49:17 -0400
Received: from mga06.intel.com ([134.134.136.21]:42763 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754727Ab2E3VtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <201205302341.21821.rjw@sisk.pl>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
	<20120530182145.23574.5156.stgit@dwillia2-linux.jf.intel.com>
	<201205302334.12247.rjw@sisk.pl>
	<201205302341.21821.rjw@sisk.pl>
Date: Wed, 30 May 2012 14:49:13 -0700
Message-ID: <CABE8wwuNLEO+jmp_08VGHFbzD94y4ZhOfrFw207d=tLWi0UJ0Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] scsi: cleanup usages of scsi_complete_async_scans
From: Dan Williams <dan.j.williams@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Len Brown <len.brown@intel.com>, mroos@linux.ee,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Bottomley <JBottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >             }
>> >
>> > -           /*
>> > -            * We can't depend on SCSI devices being available after loading
>> > -            * one of their modules until scsi_complete_async_scans() is
>> > -            * called and the resume device usually is a SCSI one.
>> > -            */
>> > -           scsi_complete_async_scans();
>> > -
>>
>> I believe this is wrong.  You're going to introduce a regression on systems
>> using built-in hibernation and built-in SCSI stack.
>
> Ah, wait.  Do I understand correctly that wait_for_device_probe()
> is now going to do an equivalent of scsi_complete_async_scans()?
>
> If so, that should work, in which case please disregard my previous
> messages in this thread.

Yeah, no problem.  Patch 3 is what changed the assumptions in this regard.

--
Dan
