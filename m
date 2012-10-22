Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2JVWXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:23:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:15502 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2JVWXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:23:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,631,1344236400"; 
   d="scan'208";a="236943106"
Message-ID: <5085B207.5010907@linux.intel.com>
Date: Mon, 22 Oct 2012 13:52:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>, Tom Rini <trini@ti.com>, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur> <50833F30.4020802@ti.com> <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com> <20121021041858.GA14809@jshin-Toonie> <50843627.4020103@ti.com> <20121021210633.GA14311@jshin-Toonie> <508467EE.4040807@ti.com> <20121022144020.GA14425@jshin-Toonie> <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com> <20121022183858.GA31185@jshin-Toonie> <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com> <5085ABEF.3060502@linux.intel.com> <CAE9FiQW0rQFUgjiYjByA91XCUUqo59zz2kXc9Z5wXk+3vKPKaQ@mail.gmail.com>
In-Reply-To: <CAE9FiQW0rQFUgjiYjByA91XCUUqo59zz2kXc9Z5wXk+3vKPKaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 01:50 PM, Yinghai Lu wrote:
> ok, let's see if we can meet this extreme corner case except user
> specify not page aligned "memmap="

If it is *only* memmap= there is a very simple solution: if the memmap
is RAM then we round up the starting address and round down the end
address; if the memmap is not RAM then we round up instead...

	-hpa

