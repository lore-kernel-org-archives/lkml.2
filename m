Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab0K3Qgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:36:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21695 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0K3Qgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:36:37 -0500
Date: Tue, 30 Nov 2010 08:36:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, WANG Cong <amwang@redhat.com>
Subject: Re: [PATCH] headers_check: better search for functions in headers
Message-Id: <20101130083607.3e1e6ec5.randy.dunlap@oracle.com>
In-Reply-To: <1291134119-12903-1-git-send-email-virtuoso@slind.org>
References: <1291134119-12903-1-git-send-email-virtuoso@slind.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 18:21:59 +0200 Alexander Shishkin wrote:

> Some headers don't bother with "extern" in function prototypes,
> which results in said prototypes being unnoticed and exported
> to userland.
> 
> This patch slightly improves detection of such cases by checking
> for C type names as well in the beginning of a line.
> 
> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> CC: Stephen Hemminger <shemminger@vyatta.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Michal Marek <mmarek@suse.cz>
> CC: WANG Cong <amwang@redhat.com>
> CC: linux-kernel@vger.kernel.org
> ---
>  scripts/headers_check.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> index 50d6cfd..e0e25a1 100644
> --- a/scripts/headers_check.pl
> +++ b/scripts/headers_check.pl
> @@ -64,7 +64,7 @@ sub check_include
>  
>  sub check_declarations
>  {
> -	if ($line =~m/^\s*extern\b/) {
> +	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
>  		printf STDERR "$filename:$lineno: " .
>  		              "userspace cannot call function or variable " .

s/call/reference/ ?

>  		              "defined in the kernel\n";
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
