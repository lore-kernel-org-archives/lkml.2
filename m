Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2FRPLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:11:23 -0400
Received: from [89.21.227.130] ([89.21.227.130]:54310 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752558Ab2FRPLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:11:23 -0400
Message-ID: <4FDF4345.40508@itdev.co.uk>
Date: Mon, 18 Jun 2012 16:03:33 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/22 v4] Input: atmel_mxt_ts - don't re-read matrix after
 applying pdata
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org> <1339992522-22073-15-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1339992522-22073-15-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> The matrix x/y size in the Info ID Block represents the number of x/y
> trace lines on the device.  There is no need to re-read them after
> applying pdata config, since pdata only configures the object table
> etnries.  The matrix size read from the ID can only be updated by a
> firmware update.

This isn't correct. For example, mXT224 can be configured as 16x14, 17x13,
18x12, etc. This only takes effect when the chip is reset, which is why it
is necessary to re-read them after applying the config.

cheers

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
