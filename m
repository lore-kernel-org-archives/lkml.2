Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0HPX5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:57:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33297 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0HPX5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:57:41 -0400
Message-ID: <4C69CFC4.8020307@zytor.com>
Date: Mon, 16 Aug 2010 16:54:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com,
        vgoyal@redhat.com, nhorman@tuxdriver.com
Subject: Re: [PATCH][EFI] Run EFI in physical mode
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>	<AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com>	<faf83501-1e53-459d-88ed-2ac5963a37f2@email.android.com>	<AANLkTimtH41djAF5OxXCeVS8cHg_JCBd+wQ1iT1BUWgX@mail.gmail.com>	<8f5e697c-e9ae-4453-aa7a-7086dd156cc9@email.android.com> <m1ocd2i0u0.fsf@fess.ebiederm.org>
In-Reply-To: <m1ocd2i0u0.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 04:39 PM, Eric W. Biederman wrote:
> 
> "H. Peter Anvin" <hpa@zytor.com> writes:
>> "huang ying" <huang.ying.caritas@gmail.com> wrote:
>>
>>> On Mon, Aug 16, 2010 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> No, it should not be dynamic; rather we should unify all the users
>>>> who need a 1:1 map and just keep that page table set around.
> 
> We still want to restore cr3 from the local task structure as soon
> as is reasonable, as an identity mapped page table will have page 0
> mapped and thus hide null pointer dereferences.
> 

Absolutely!

>>> Agree. One known issue of global 1:1 map is that we need to make at
>>> least part of page table PAGE_KERNEL_EXEC for EFI runtime code, and
>>> change_page_attr can not be used before page allocator is available.
> 
>> For the 1:1 map we probably should make all pages executable; other
>> things need it too, but we shouldn't have it mapped in except when
>> needed.
> 
> We need to be careful in the setup of the global page table so that
> we are in sync with the pat structure for the attributes pages
> are mapped so that we don't map a page as cached and uncached
> at the same time.  Otherwise we could accidentally get cache
> corruption.  To do that would seem to mean change_page_attr
> is relevant at least after we switch from our default set of
> page permissions.

Quite, which is yet another reason to have a common global page table
for all the 1:1 users... right now this is all ad hoc.

	-hpa
