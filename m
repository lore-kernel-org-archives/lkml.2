Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1D3MmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:42:09 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:60223 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186Ab1D3MmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:42:04 -0400
X-AuditID: 12074423-b7b8eae000003d4f-25-4dbc03a02e98
Message-ID: <4DBC038F.3080004@mit.edu>
Date: Sat, 30 Apr 2011 08:41:51 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com,
        joe@perches.com, randy.dunlap@oracle.com, trivial@kernel.org
Subject: Re: [Oops 1/2]Something wrong with copy_from_user() function
References: <20110430061336.GA4274@gmail.com>
In-Reply-To: <20110430061336.GA4274@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsUixCmqrbuAeY+vwbmbNhZz1q9hszi3YAaj
	xez7j1ksLu+aw2axfMk2Nov3+y8zObB5bFrVyebx9mGAx4kZv1k8Pj69xeLxZdU1Zo/Pm+QC
	2KK4bFJSczLLUov07RK4MnqP/mcreMdWsWlSC0sD42HWLkZODgkBE4n37buYIWwxiQv31rN1
	MXJxCAnsY5TYt3M+M4SzgVGi994/VgjnLZPEy++3mUBaeAXUJF78u8MIYrMIqEr8mH4BbCyb
	gIpEx9IHYDWiAuUSp19PY4aoF5Q4OfMJC8ggEYFJjBInzjwDSwgLuErMP3sPrEFIQFdi1qR3
	YDangJ7Ez4/3gW7i4GAWsJb4trsIJMwsIC+x/e0c5gmMArOQjJ2FUDULSdUCRuZVjLIpuVW6
	uYmZOcWpybrFyYl5ealFumZ6uZkleqkppZsYQUHP7qK8g/HPQaVDjAIcjEo8vN6/dvkKsSaW
	FVfmHmKU5GBSEuVlZdrjK8SXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE1/EsUDlvSmJlVWpRPkxK
	moNFSZx3rqS6r5BAemJJanZqakFqEUxWhoNDSYL3JchQwaLU9NSKtMycEoQ0EwcnyHAeoOGm
	wCQhxFtckJhbnJkOkT/FqCglzisBkhAASWSU5sH1wpLSK0ZxoFeEec1AqniACQ2u+xXQYCag
	wfeLdoIMLklESEk1MB4x2J257QqXXu6nXreZ+XM+iT0UunOX6cKMihkn/s7x2GWy26I49cGT
	okUP8viqt026vobj2yYBm5YuwcgHx3ZeDJweXLnYRsjnd0T54hvOc2uSimU/feV0ey7jKqok
	PGeFfeurTxO4jDZqLp58TYL9VLPRs2L3kIJlxn9C/2qtsvUwezi70V+JpTgj0VCLuag4EQAM
	vR9UJQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 02:13 AM, Harry Wei wrote:
> Hi us,
> 	When i was compiling 2.6.38.2 kernel. Something wrong happend to me.
> It shows like following.
>
> [...]
> Warning: call to 'copy_from_user_overflow' declared with attribute warning:
> copy_from_user buffer size is not provably correct.
> [...]
>
> See http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=report_bug.png for details.
> 	I tried to fix this warning, but i don't know how to deal with
> it. Can anyone help me.

That's a bug (maybe) in drivers/staging/vt6656/wpactl.c, which is a 
staging driver and therefore liable to be imperfect.  You could ignore 
it or fix it and submit a patch.

(The bug isn't in copy_from_user -- it's an intentional warning in there 
to indicate that something might be wrong with the caller.)

--Andy

>
> Thanks.
> Harry Wei.

