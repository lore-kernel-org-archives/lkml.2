Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab0EGGp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:45:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44319 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab0EGGpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:45:25 -0400
X-Sasl-enc: f8vehpLMynXkBW2hFaL3U2CFlepkWy1/N/IMhmTjGvMy 1273214704
Message-ID: <4BE3B6EF.2030608@ladisch.de>
Date: Fri, 07 May 2010 08:45:03 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Don Prince <dhprince.devel@yahoo.co.uk>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2.6.34-rc5] HID: Prodikeys PC-MIDI HID Driver
References: <4BE1A2E2.1040801@yahoo.co.uk> <4BE261FE.60109@ladisch.de> <4BE30935.9040001@yahoo.co.uk>
In-Reply-To: <4BE30935.9040001@yahoo.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Prince wrote:
> On 06/05/10 07:30, Clemens Ladisch wrote:
>> I'd guess you want to remove the OUTPUT and DUPLEX flags and to drop all
>> output-related functions.
>
> I know, it was naff, but without it the I get this from "amidi"
> 
> $ amidi -l
> Dir Device    Name
> cannot get rawmidi information 2:0: No such file or directory
> 
> Is it supposed to print this?

Try the latest alsa-utils version.

> 90 32 00
> 80 32 7F

In MIDI, note-on commands with velocity zero must be interpreted as
note-off.  If the device reports such a velocity for a key press, you
have to make it nonzero.


Regards,
Clemens
