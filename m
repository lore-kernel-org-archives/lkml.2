Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab2HPT4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:56:09 -0400
Received: from mga05.intel.com ([192.55.52.89]:32518 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932118Ab2HPT4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4i6CYNmxbHHfgEYqPHVD=_PDqurFyrZzzL5jb0rdVj8w@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
	<CA+5PVA4i6CYNmxbHHfgEYqPHVD=_PDqurFyrZzzL5jb0rdVj8w@mail.gmail.com>
Date: Thu, 16 Aug 2012 22:56:02 +0300
Message-ID: <CALLzPKb-qpAJCThHxukEUGGhOWUTxr5wCP7C1MmZfNZrdMViGg@mail.gmail.com>
Subject: Re: [RFC v2 4/7] modsig: add integrity_module_check hook
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 9:49 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
>> @@ -2437,6 +2438,14 @@ static int copy_and_check(struct load_info *info,
>>
>>         info->hdr = hdr;
>>         info->len = len;
>> +
>> +       err = integrity_module_check(hdr, len);
>> +       if (err < 0)
>> +               goto free_hdr;
>> +
>> +       /* cut signature tail */
>> +       info->len = err;
>> +
>>         return 0;
>>
>>  free_hdr:
>
> So if I'm reading this correctly, any module that fails signature
> verification will fail to load.  That makes sense, but I wonder if you
> intend to support a non-enforcing mode for module signatures at all?
> Actually, a brief document in Documentation describing how this whole
> mechanism works and what the fail states are would be good.  David's
> patches have it nicely spelled out and I don't see anything similar in
> your patch set.
>
> josh

Hi,

I had enable and enforce mode in my previous patches.
I have removed them just before posting.
I added now enforcing back..

- Dmitry
