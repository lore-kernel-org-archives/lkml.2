Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1LVVRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:17:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48925 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1LVVRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:17:47 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1324550480-26308-1-git-send-email-alokc@nvidia.com>
References: <1324550480-26308-1-git-send-email-alokc@nvidia.com>
Date: Thu, 22 Dec 2011 13:17:46 -0800
Message-ID: <CAOesGMire-13yiA9gVQYFWdTa6ZLJLbTW8qoRoPMRQ1ExavVUQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: tegra: Add delay before reset the controller
From: Olof Johansson <olof@lixom.net>
To: Alok Chauhan <alokc@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        bones@secretlab.ca, paul.gortmaker@windriver.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, dgreid@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding linux-tegra and Dylan Reid who was debugging this before)

On Thu, Dec 22, 2011 at 2:41 AM, Alok Chauhan <alokc@nvidia.com> wrote:
> From: Alok Chauhan <alokc@nvidia.com>
>
> In NACK error condition, I2C controller violates
> clock-to-data setup time before stop. In Software,
> because of this reset of controller is happening
> before I2C controller could complete STOP condition.
>
> Added worst case delay of 1 ms (assuming lowest
> clock frequency will be 1 KHZ) before reset the
> controller in case of NACK error.

This change causes problems systems with some models of i2c TPMs, since
the first transaction to them will always time out (TPM quirk), and the delay
means that the tpm will have time to go back to sleep and thus timeout
even on the retry. So you'll never make progress.

In other words: this patch will break some systems and thus shouldn't be
applied.


-Olof
