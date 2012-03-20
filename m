Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030261Ab2CTPBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:01:41 -0400
Received: from [89.21.227.130] ([89.21.227.130]:34755 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758036Ab2CTPBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:01:40 -0400
Message-ID: <4F689BD0.7090002@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:01:36 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH 07/20] Input: atmel_mxt_ts - add backupnv sysfs entry
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-8-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-8-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> Writing to the object sysfs entry permits individual object table entries
> to be modified in the device RAM at run time.  To permanently save
> the settings, they must be written to Non-Volatile memory (NVM).
> This patch adds a write-only sysfs entry to allow userspace to save
> current settings to NVM, but restricts access to root.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

The process to update the stored chip configuration should be:

1) Change config setting
2) Backup (with delay)
3) Reset (with delay)
4) Get driver to re-read resolution etc

So I am worried that this is a half solution, and will lead to confusion.

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
