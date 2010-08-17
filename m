Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0HQGZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:25:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0HQGZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:25:41 -0400
Message-ID: <4C6A2ABD.1090002@suse.cz>
Date: Tue, 17 Aug 2010 08:22:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>,
        Linux is full of bugs <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: BUG: nconfig doesn't preserve case in its menu display
References: <AANLkTimDmwmC3xDJVXB1LXJzMJTuamCswVeC5v42zU-Q@mail.gmail.com> <4C69F7B9.2000103@cn.fujitsu.com>
In-Reply-To: <4C69F7B9.2000103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.8.2010 04:45, Li Zefan wrote:
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

Nir removed the hotkeys feature in completely, can you try if the
problem persists in the for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git ?
The commit is a72f3e2.

Michal
