Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0IMLSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:18:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0IMLSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=rXCbtNLO1FgFd0TrJgWYgqU/YlWrU2Rm9rTk9z3ZRCadAkQscJSB/wzYHrBdQBUTGn
         5UbpPYfruGXfvktWflbKNCctRL69+4ctjL/IK4P5xicHjzgXba4UU98xzH7cjyQRCKLc
         zAVnlJGLVZb0BifA10VJutxeTE/hSa9F+XX1I=
Message-ID: <4C8E0892.3000306@suse.cz>
Date: Mon, 13 Sep 2010 13:18:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: phil@ipom.com
CC: stable@kernel.org, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [34-stable regression] USB delay init quirk causes device events
 loss
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this commit:
commit 93362a875fc69881ae69299efaf19a55a1f57db0
Author: Phil Dibowitz <phil@ipom.com>
Date:   Thu Jul 22 00:05:01 2010 +0200

    USB delay init quirk for logitech Harmony 700-series devices

causes a lot of pain for users who loose events from their input devices:
https://bugzilla.novell.com/show_bug.cgi?id=638200

opensuse 11.3 uses 2.6.34 stable and that's how the patch got there.
Reverting it makes it work again.

The problem is that the patch shuffles with usb_detect_quirks which used
to disable autosuspend by default. Apparently it no longer does.

regards,
-- 
js
suse labs
