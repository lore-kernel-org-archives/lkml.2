Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2LJKWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:22:35 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52713 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab2LJKWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:22:33 -0500
Message-ID: <50C5B7E3.2080909@imgtec.com>
Date: Mon, 10 Dec 2012 10:22:27 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH v2 03/44] Add CONFIG_HAVE_64BIT_ALIGNED_STRUCT for taskstats
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-4-git-send-email-james.hogan@imgtec.com> <50C2B751.5000507@zytor.com>
In-Reply-To: <50C2B751.5000507@zytor.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_10_10_22_28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/12 03:43, H. Peter Anvin wrote:
> On 12/05/2012 08:08 AM, James Hogan wrote:
>> On 64 bit architectures with no efficient unaligned access, taskstats
>> has to add some padding to a reply to prevent unaligned access warnings.
>> However this also needs to apply to 32 bit architectures with 64 bit
>> struct alignment such as metag (which has 64 bit memory accesses).
> 
> Wait... 64-bit struct alignment on structures with only 32-bit members?
>  That might be... interesting... in a number of places...

Hi,

I'll rewrite the description as it's a bit misleading. On metag 64bit
struct alignment is required when it contains 64bit members, not if it
only contains 32bit members. Although metag is a 32bit arch, it can do
64bit memory accesses which must be aligned.

Thanks for taking a look.

James

