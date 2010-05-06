Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0EFBkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 21:40:21 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:59119 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0EFBkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 21:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H+vIBKwSkJumaAF/UzvDqNoCTRBz95f+67SPVKjjLr173TXKuw5wk0bNVZ7RmEu2Ux
         VM1KIAWtjbN2OLCo4fyqZL+7+/BPOIJx0Ws6eltLt3FwmHQ+giLOEJl1ycEQZWgQy8xw
         41BRWrIIyIX36HSgekScWjdm4UbJ1535Y+q2g=
MIME-Version: 1.0
In-Reply-To: <20100504152724.GA2184@srcf.ucam.org>
References: <20100504004338.GA22678@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005040949060.1729-100000@iolanthe.rowland.org>
	 <20100504152724.GA2184@srcf.ucam.org>
Date: Thu, 6 May 2010 10:40:18 +0900
Message-ID: <AANLkTinWEmlrBs5T_SX2h-YFY_OSgcDFLO18SuqZT9RN@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Magnus Damm <magnus.damm@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 12:27 AM, Matthew Garrett <mjg@redhat.com> wrote:
> On Tue, May 04, 2010 at 09:51:39AM -0400, Alan Stern wrote:
>
>> Another thing that Kevin is missing: There is more to the system than
>> the devices and the CPU.  For example: RAM, an embedded controller (on
>> modern desktop/laptop systems), a power supply, and so on.  Dynamic PM
>> for the CPU and the devices won't power-down these things, but system
>> PM will.
>
> Somewhat true - machines with C1E support will put the RAM into self
> refresh when the cpu is idle, but you're right that there are various
> components that we simply don't have control over in the desktop world
> at present.

As a contrast, at least on some embedded SoCs without firmware
limitations the low level sleep code for Runtime PM / CPU Idle is
shared with system wide suspend. So the RAM is put into self refresh
regardless of entering a half-deep CPU Idle state or entering
suspend-to-memory.

I've heard that newer SH-Mobile ARM hardware monitors the memory bus
activity behind the scenes and can put the system RAM into self
refresh automatically. On older parts we had to manage that from CPU
idle context.

/ magnus
