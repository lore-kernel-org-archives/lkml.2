Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0EDPN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:13:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45078 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab0EDPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:13:58 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, <magnus.damm@gmail.com>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
References: <Pine.LNX.4.44L0.1005040949060.1729-100000@iolanthe.rowland.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 04 May 2010 08:13:53 -0700
In-Reply-To: <Pine.LNX.4.44L0.1005040949060.1729-100000@iolanthe.rowland.org> (Alan Stern's message of "Tue\, 4 May 2010 09\:51\:39 -0400 \(EDT\)")
Message-ID: <876333og26.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Tue, 4 May 2010, Matthew Garrett wrote:
>
>> On Mon, May 03, 2010 at 04:37:22PM -0700, Kevin Hilman wrote:
>> 
>> > Please forgive the ignorance of ACPI (in embedded, we thankfully live
>> > in magical world without ACPI) but doesn't that already happen with
>> > CPUidle and C-states?  I think of CPUidle as basically runtime PM for
>> > the CPU.  IOW, runtime PM manages the devices, CPUidle manages the CPU
>> > (via C-states), resulting in dynaimc PM for the entire system.  What
>> > am I missing?
>> 
>> ACPI doesn't provide any functionality for cutting power to most devices 
>> other than shifting into full system suspend. The number of wakeup 
>> events available to us on a given machine is usually small and the 
>> wakeup latency large, so it's not terribly practical to do this 
>> transparently on most hardware.
>
> Another thing that Kevin is missing: There is more to the system than
> the devices and the CPU.  For example: RAM, an embedded controller (on
> modern desktop/laptop systems), a power supply, and so on.  Dynamic PM
> for the CPU and the devices won't power-down these things, but system
> PM will.

I consider all of those things devices.

On non-ACPI systems where the kernel has to manage all of the above
directly, we have drivers for all of them using runtime PM as well as
the regulator framework for dynamic PM power supplies.

Kevin
