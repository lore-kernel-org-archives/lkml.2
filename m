Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2BBJQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:16:36 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:58871 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2BBJQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:16:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120201145707.GD30184@srcf.ucam.org>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
	<1323789196-4942-3-git-send-email-amit.kachhap@linaro.org>
	<20120201145707.GD30184@srcf.ucam.org>
Date: Thu, 2 Feb 2012 14:46:31 +0530
Message-ID: <CAK44p23gUr=y4h_VUsy4_NWQvVRbG=EmLLXkZN3Lp-HnGsuPYQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] thermal: Add generic cpu cooling implementation
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2012 20:27, Matthew Garrett <mjg@redhat.com> wrote:
> On Tue, Dec 13, 2011 at 08:43:16PM +0530, Amit Daniel Kachhap wrote:
>> This patch adds support for generic cpu thermal cooling low level
>> implementations using frequency scaling and cpuhotplugg currently.
>
> We've been over this kind of thing in the past. cpu hotplug is a
> relatively expensive operation, so people have previously been
> enthusiastic about using the scheduler to simply avoid running anything
> on CPUs if they're overheating. Has any general consensus been reached
> on this?
yes you are right that cpuhotplug is an expensive process and it may
further heat up the system before turning off so the ideal way would
be to reduce the capacity of the cpu gradually. Anyway these patches
are only exporting those API's and the actual use of them depends on
the user. Although my bigger focus is on cpufreq as cooling devices so
I might remove cpuhotplug in the next version.
>
> I'm also not entirely thrilled at now having two ways to manage the cpu
> through the thermal layer. ACPI already plugs in via the passive trip
> points. If we're going to do this then I'd like to see the ACPI code
> merged in with the generic cpu cooling code.
Yeah I also agree that there is a kind of repetition and not entirely
sure where to place these codes. I will try adding them inside acpi.
Thanks for the suggestion.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
