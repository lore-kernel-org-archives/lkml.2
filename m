Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab0LMRqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:46:22 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41952 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab0LMRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:46:20 -0500
Message-ID: <4D065BDE.5020107@canonical.com>
Date: Mon, 13 Dec 2010 09:46:06 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 09:24 AM, Henrik Rydberg wrote:
> +- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
> +is not well-defined, and is only used for legacy hardware. The real contact
> +positions are to be found within the bounding rectangle formed by the
> +envelope contact positions.

By definition, this only covers rectangles with two coordinates to
define the shape and location. Why do we want to call it envelope? It's
just extra confusion to me. Why not call it MT_TOOL_RECT?

Please describe how to use this tool type. Its usage is different than
any tool type usage before, so an explanation would be helpful. Must the
value of the tool on the first touch be 0 until a second touch can
define the rect? Or, can touches always default the value to 1 since
we're talking about devices that only support two fingers?

If this is really to remedy only poor two finger devices, would it be
better to flag the device itself somehow to say "don't trust this
device's coordinate positions" (or something more elegant)? This would
prevent an extrapolation of tool types to multiple fingers at a time.

Lastly, using tool types for this seems odd since this does not signify
a physical tool. It merely signifies that the device coordinates cannot
be trusted literally. Maybe we should use some other namespace for
binding information across multiple touches, like MT_BIND_RECT?

-- Chase
