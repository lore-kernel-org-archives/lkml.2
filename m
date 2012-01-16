Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2APONS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:13:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57781 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab2APONR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:13:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAK44p203s3Eg8n2C_SXiFDEOsL3hQ2J34e0kFE9T=Um6kFZd1Q@mail.gmail.com>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
	<1323789196-4942-3-git-send-email-amit.kachhap@linaro.org>
	<CAMXH7KEBCTWDsSFn+ZUsbetvbWXO3N9ZMpLBvLm0n0r2RH1wuQ@mail.gmail.com>
	<CAK44p203s3Eg8n2C_SXiFDEOsL3hQ2J34e0kFE9T=Um6kFZd1Q@mail.gmail.com>
Date: Mon, 16 Jan 2012 08:13:16 -0600
Message-ID: <CAMXH7KGR7UCc42TJrVyR7WehDCHczOL2NCnZQe7giLXccF3RbA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] thermal: Add generic cpu cooling implementation
From: Rob Lee <rob.lee@linaro.org>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        rui.zhang@intel.com, linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I don't like how ACTIVE does not have available notification callbacks
>> like HOT and CRITICAL do.  Perhaps I fail to grasp why they aren't there
>> but besides just applying a cooling device, one might want to do something
>> else as well upon hitting these trip points.  So that said, it might be nice
>> to add a notification to STATE_ACTIVE as well.
> Well I added ACTIVE_STATE trip type as just some additional features
> over trip type ACTIVE. Also each thermal zone can have more then one
> trip types so HOT notifications can still be used. But I like your
> suggestion of putting notfications in all the trip types. Lets see if
> the maintainers agree to this idea.
Thinking about it a bit more, I didn't consider HOT because it only
notifies when you cross above this trip point and not below and the
use case I had in mind would ideally want to be notified in both
cases.  Also, if ACTIVE/ACTIVE_STATE trip types will always have
cooling devices bound to them, then the notification could be put in
the cooling device code if desired.  I think these features are
separate from your main effort and can be addressed in separate future
patch.
