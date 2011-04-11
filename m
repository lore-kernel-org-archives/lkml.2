Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1DKS47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:56:59 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52774 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755572Ab1DKS44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:56:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cLQqoGtoXkdf1KdT1lIDyWsIg4XraZX9AtfFJo0vBALm1m4UUf1hC762fqv4CFu2gY4ElKlU2J78zw4PgOfTTAazPn1HENsUkUrn86skUuFCBLH9MhqBzrwbxl1Nwg2V;
Date: Mon, 11 Apr 2011 11:56:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC]Documentation:accounting:getdelays.c Fix: warning:
 variable =?UTF-8?B?4oCYaeKAmQ==?= set but not used
Message-Id: <20110411115654.9ff67799.rdunlap@xenotime.net>
In-Reply-To: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>
References: <1302019370-7101-1-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Apr 2011 09:02:50 -0700 Justin P. Mattock wrote:

> The below patch takes care of the warning, but keep in mind am unsure if this is a correct way
> to resolve this issue.
> Documentation/accounting/getdelays.c: In function ‘main’:
> Documentation/accounting/getdelays.c:436:7: warning: variable ‘i’ set but not used [-Wunused-but-set-variable]
> 
> Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
> Documentation/accounting/getdelays.c: In function ‘get_family_id’:
> Documentation/accounting/getdelays.c:172:14: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

Hi,
Does -Wunused-but-set-variable require gcc 4.6.0?


>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  Documentation/accounting/getdelays.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index e9c7778..16e16d5 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -433,8 +433,6 @@ int main(int argc, char *argv[])
>  	}
>  
>  	do {
> -		int i;
> -
>  		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
>  		PRINTF("received %d bytes\n", rep_len);
>  
> @@ -459,7 +457,6 @@ int main(int argc, char *argv[])
>  
>  		na = (struct nlattr *) GENLMSG_DATA(&msg);
>  		len = 0;
> -		i = 0;
>  		while (len < rep_len) {
>  			len += NLA_ALIGN(na->nla_len);
>  			switch (na->nla_type) {
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
