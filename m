Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1IYMyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 08:54:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1IYMyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 08:54:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=THq2lsaoXOZc76nyVHdWFpKnsyipMFQDLVuO6Pmv8Wf4Ssiz0TSy2/Q//b7bA5yXn
	REZK5LvBX4AMnVuY1QZIw==
MIME-Version: 1.0
In-Reply-To: <1316818998-30711-1-git-send-email-sjg@chromium.org>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 25 Sep 2011 06:54:26 -0600
Message-ID: <CAErSpo63fYmQVRO2O3sB37k6rAo7Qttdh1xo=WH+QwcVb+neGg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
To: Simon Glass <sjg@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 5:03 PM, Simon Glass <sjg@chromium.org> wrote:
> This experimental patch set adds boot timing to a Linux system. The
> timing starts with the boot loader and extends through the kernel into
> user space to the completion of the boot process. The timing starts when
> the system leaves reset, not later when the kernel starts.
>
> The concept is:
> - Boot loader records a timestamp for key events during its operation
> - These timestamps are passed to Linux, which adds more as it boots
> - These timestamps are made available to user space, where more
> timestamps are added as init does its job
> - Finally the whole record is collected by a user-space script run at
> the end of init. This is fed back through some mechanism to monitor
> boot time in the field.

I think this is a cool idea.  It's quite difficult to extract this
sort of information today, and making it easily and consistently
available should help focus attention and improve things.

There are difficult issues about which clock to use, how to correlate
bootloader & kernel timestamps, how to make sure the timestamps stay
sensible even when we use hwclock, ntp, etc., but I think it's worth
pushing on this to see how far you can go.

Bjorn
