Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0HQCnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:43:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0HQCnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:43:20 -0400
Message-ID: <4C69F860.9050209@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 10:48:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: BUG: nconfig doesn't preserve case in its menu display
References: <AANLkTimDmwmC3xDJVXB1LXJzMJTuamCswVeC5v42zU-Q@mail.gmail.com> <4C69F7B9.2000103@cn.fujitsu.com>
In-Reply-To: <4C69F7B9.2000103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> 于 2010年08月17日 05:04, Ævar Arnfjörð Bjarmason 写道:
>> When I do "make nconfig" and go to "General Setup" my "Local version -
>> append to kernel release" entry appears as:
>>
>>     (-avar-akbar) Local version - append to kernel release
>>
>> When I use "make menuconfig" it's:
>>
>>     (-Avar-Akbar) Local version - append to kernel release
>>
>> And my .config agrees:
>>
>>     $ ack -n1 CONFIG_LOCALVERSION .config
>>     CONFIG_LOCALVERSION="-Avar-Akbar"
>>
>> But when I edit the version string in both menuconfig and nconfig it
>> retains the correct casing.
>>
>> I briefly searched through the nconfig code, but couldn't find
>> anything pertinent to the localversion, so this is probably a more
>> general issue.
> 
> The bug is in make_hot(). Here is the fix:
> 
> =======================
> 
> From: LiZefan <lizf@lizf.localdomain>

Change it to:

From: Li Zefan <lizf@cn.fujitsu.com>
