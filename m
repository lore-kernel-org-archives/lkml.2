Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2AMPqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:46:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63376 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab2AMPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:46:23 -0500
Message-ID: <4F1051CA.4090007@gmail.com>
Date: Fri, 13 Jan 2012 16:46:18 +0100
From: Enrico Mattea <ocirne94@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: HID device calibration - how to override mapping?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a HID device (racing pedals) and a problem with it.

In short, one of the three axes of the device (the clutch pedal) sends 
raw values differently from the other two; in the sense that gas and 
brake pedal return +32767 to 0 to -32767 (from released to halfway to 
fully pressed), while the clutch pedal sends 0 to -32767 to +32767 to 0 
(from released (0) to halfway (-32767), then the value jumps to +32767, 
then decreases again to 0 when fully pressed).

This obviously makes it impossible to properly calibrate the axis for 
anything, because of the "jump" at halfway and of the equality of min 
and max returned values.

As nobody seems to be complaining about this anywhere, I think that the 
(windows only) pedals' driver acts on the clutch value in some way at 
kernel level, "interpreting" it correctly.

So please, is there a way to do something similar - what I'm thinking 
about is remapping the values (at HID kernel driver level) - so that the 
values are interpreted correctly by the kernel?

Thank you very much in advance,
Ocirne
