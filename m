Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3AIBHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:07:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53606 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3AIBHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:07:16 -0500
MIME-Version: 1.0
In-Reply-To: <87txqruq8p.fsf@xmission.com>
References: <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<20130107152622.GD3219@phenom.dumpdata.com>
	<CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
	<87txqruq8p.fsf@xmission.com>
Date: Tue, 8 Jan 2013 17:07:14 -0800
X-Google-Sender-Auth: GbcdG5oDC_55yKNJj7dhbqKs0kQ
Message-ID: <CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 4:58 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:

>
> So instead we need to say?
>
> +       if (no_iotlb_memory)
> +               panic("Cannot allocate SWIOTLB buffer");
> +
>
> Which is just making the panic a little later than it used to be and
> seems completely reasonable.

yes, looks some driver just use map_single without checking results.
