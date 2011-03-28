Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1C1Sd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:33:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46264 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1C1Sdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:33:55 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate key
Date: Mon, 28 Mar 2011 13:33:41 -0500
Message-Id: <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 02:14:33PM +0000, Corentin Chary wrote:
> But since Dmitry and Chris seems to prefer the autorepeat approach
> with a single key code, if it works then it's ok, we just need to set
> REP_DELAY, report press and release events, and drop 0xea events.

New patches follow. I didn't set REP_DELAY (or REP_PERIOD) because the
input core interprets this to mean that the driver will handle the
autorepeat itself. There's always EVIOCSREP to change the delay and
repeat period from userspace.

Changes since v2:

 - Fixed incorrect types of key_filter() arguments
 - Use a single key code, KEY_CONFIG, for this button
 - Simplify filtering to only emit events for press and release
 - Added a patch to enable autorepeat for hotkey input device

