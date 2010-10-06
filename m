Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0JFKJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:09:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0JFKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YeXRu/k/j4ZKW7bOv25XXSfPHSP5p5qZhrHpsSx1+5Nf8+4vJkXv7NA63BfJLALHP0
         h7IwVrQjpSXxXls5DORR3VHdSgZW60Be0OQCkaI6gaAjxxMC8PRsBx8ICAkxxcAwkzyC
         /APb7y4LsmScYbHDBM+AV25zaYsUWhiYq49NE=
Message-ID: <4CAC4AC3.60507@gmail.com>
Date: Wed, 06 Oct 2010 12:09:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 0/2] HID: hidraw, fix two NULL pointer dereferences
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>	<1286292017-6746-1-git-send-email-ospite@studenti.unina.it>	<4CAB94A0.8040402@gmail.com> <20101006120129.52da81d3.ospite@studenti.unina.it>
In-Reply-To: <20101006120129.52da81d3.ospite@studenti.unina.it>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 12:01 PM, Antonio Ospite wrote:
> On Tue, 05 Oct 2010 23:12:00 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> On 10/05/2010 05:20 PM, Antonio Ospite wrote:
>>> here are some fixes to hidraw.
>>>
>>> Patches are against 2.6.36-rc6, but they should be ported to other
>>> maintained stable kernels as well.
>>>
>>> Antonio Ospite (2):
>>>   HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
>>>   HID: hidraw, fix a NULL pointer dereference in hidraw_write
>>
>> Hi, please fix also the window in hidraw_release.
>>
> 
> I am not sure I get what you mean, can you please add more details?

Sure. Look at the code:
if (!hidraw_table[minor])
        return -ENODEV;
...
dev = hidraw_table[minor];
if (!--dev->open) {
...

This is done without minors_lock, so you can easily have dev being NULL
even though the first if.

regards,
-- 
js
