Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1AGWGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:06:42 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33418 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1AGWGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AtFdiUSwvTVTOT53sMweRNSZobIMGKWdYCrQis/68Gy7B2UYfFm+4YpVCrTQHGn81x
         tlJ0fBcFlq76s6JhFRfsAaOPj5HEX+f+mD0yhSBe4kx3bkeBNQtlQWJ5HhPLayL5vmH5
         aSBkZV7TWlwz2ZvzWZYxYt06GAS99os2nuGgs=
Message-ID: <4D278E6B.7020002@gmail.com>
Date: Sat, 08 Jan 2011 01:06:35 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 12:28 AM, Chase Douglas wrote:
> +* BTN_TOOL_<name>:
> +  - These codes are used in conjunction with input trackpads, tablets, and
> +    touchscreens. These devices may be used with fingers, pens, or other tools.
> +    When an event occurs and a tool is used, the corresponding BTN_TOOL_<name>
> +    code should be set to a value of 1. When the tool is no longer interacting
> +    with the input device, the BTN_TOOL_<name>  code should be reset to 0. All
> +    trackpads, tablets, and touchscreens should use at least one BTN_TOOL_<name>
> +    code when events are generated.

There are some tablets (namely UC-Logic ones), which do not indicate tool
proximity. Yet they may have both a pen and a mouse. They just send reports
with separate report IDs. Currently it is solved by using
HID_QUIRK_MULTI_INPUT and not sending any BTN_TOOL_* events.

Should the documentation reflect the fact that some tablets do not send any
BTN_TOOL_* events, or should the drivers be updated to synthesise them?

Note that in the latter case there will never be a BTN_TOOL_* with
zero value when the tool leaves the digitizing area, but only when the tools
are switched (if ever).

Sincerely,
Nick
