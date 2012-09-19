Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2ISCVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:21:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43037 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2ISCVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:21:14 -0400
Message-ID: <50592C15.8060505@kdau.com>
Date: Tue, 18 Sep 2012 19:21:09 -0700
From: Kevin Daughtridge <kevin@kdau.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>,
        Sergei Shtylyov <sshtylyov@mvista.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbhid: call report_fixup before comparing descriptors
References: <50578272.1020902@kdau.com> <20120918161615.GA1439@polaris.bitmath.org>
In-Reply-To: <20120918161615.GA1439@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/12 09:16 N.U., Henrik Rydberg wrote:
> You can use dev_rdesc here instead.
Hi Henrik. Thanks for the tip. I tried comparing rdesc to hid->dev_rdesc 
without any report_fixup call, but the problem (device nonfunctional 
with "reset_resume error 1" message) still occurred. Upon looking at 
hid_open_report, I noticed that it calls report_fixup on dev_rdesc 
(pointer copied to "start") before it is kmemdup'd to rdesc. For most 
HID drivers, the report_fixup method directly modifies and returns the 
passed structure instead of returning a new pointer, so dev_rdesc is 
also modified. Assuming that dev_rdesc is supposed to be the unmodified 
data, I moved the report_fixup call in hid_open_report to after the 
kmemdup. This combination successfully solves the original problem. I'll 
submit a new patch version presently that addresses both points.

On 09/18/12 05:00 N.U., Sergei Shtylyov wrote:
> Your patch is whitespace damaged, i.e. has all tabs replaced by spaces. 
Hi Sergei. Thanks for catching that. The munging problem was supposedly 
fixed in Thunderbird years ago! I guess I'll just mail the new version 
from the command line.

-Kevin
