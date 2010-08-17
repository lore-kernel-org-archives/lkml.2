Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab0HQECA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:02:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57422 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0HQEB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jkH9fWqaO/+warFmhvUAg6OxGCeUkP9BEaIS7mpIclMw6OBbpsWnPq7oVDmSWZSl6Y
         D9k+nx4UwwBxtbXzvH1PoWRPEtUtIyYlKBejFssgwfeq2PD2CvWZ+Si2XfPfg4JC4kve
         3rGq2PnXsvbi6wU3g4N5eDrmJIlxofn+FZhjk=
MIME-Version: 1.0
In-Reply-To: <4C69F7B9.2000103@cn.fujitsu.com>
References: <AANLkTimDmwmC3xDJVXB1LXJzMJTuamCswVeC5v42zU-Q@mail.gmail.com>
	<4C69F7B9.2000103@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 04:01:58 +0000
Message-ID: <AANLkTi==O7cKcM19iO=7XoZo3PndPBDctPy08NrbYSxx@mail.gmail.com>
Subject: Re: BUG: nconfig doesn't preserve case in its menu display
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 02:45, Li Zefan <lizf@cn.fujitsu.com> wrote:
> 于 2010年08月17日 05:04, Ævar Arnfjörð Bjarmason 写道:
>> When I do "make nconfig" and go to "General Setup" my "Local version -
>> append to kernel release" entry appears as:
>>
>>     (-avar-akbar) Local version - append to kernel release
>>
>> When I use "make menuconfig" it's:
>>
>>     (-Avar-Akbar) Local version - append to kernel release
>>
>> And my .config agrees:
>>
>>     $ ack -n1 CONFIG_LOCALVERSION .config
>>     CONFIG_LOCALVERSION="-Avar-Akbar"
>>
>> But when I edit the version string in both menuconfig and nconfig it
>> retains the correct casing.
>>
>> I briefly searched through the nconfig code, but couldn't find
>> anything pertinent to the localversion, so this is probably a more
>> general issue.
>
> The bug is in make_hot(). Here is the fix:

That fixes the issue with strings inside (), but now e.g. "General
setup" on the main screen will be "GEneral setup".
