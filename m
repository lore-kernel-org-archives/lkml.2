Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0FZPtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 11:49:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58415 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0FZPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 11:49:16 -0400
Message-ID: <4C26219F.3010206@colorfullife.com>
Date: Sat, 26 Jun 2010 17:49:51 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Subject: Re: 2.6.35-rc3: System unresponsive under load
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <20100621200118.GA4021@nb-core2.darkstar.lan> <4C223657.3030507@colorfullife.com> <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com> <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com> <4C251AFF.70803@colorfullife.com> <AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com> <4C2620F4.7030900@colorfullife.com>
In-Reply-To: <4C2620F4.7030900@colorfullife.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/26/2010 05:47 PM, Manfred Spraul wrote:
> Hi Luca,
>
> On 06/26/2010 02:52 PM, Luca Tettamanti wrote:
>> They don't seem really hung as before, I see two different behaviours:
>> * Near the end of the run ab is frozen for a few seconds, but in the
>> end all requests are processed; however I see a few "length" errors,
>> meaning that the received page does not match the expected content
>> (I'm testing a static page):
>>
> That's consistent with what I see:
> If I run:
> #./semtimedop 100 100&
> #./semtimedop 100 100&
> #./semtimedop 100 100&
> #./semtimedop 100 100&
>
Sorry for the noise, but I forgot one important piece:
The patch from

http://marc.info/?l=linux-mm&m=127750107030238

must be applied - otherwise you'll just see errors due to IN_WAKEUP.

--
     Manfred
