Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1EWCQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:16:20 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:36278 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755370Ab1EWCQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:16:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:X-Identified-User;
	b=E0DMq4MI5VrQLDenu1Bwnt57XEAifsJ6QOY4bB/WdhPSckeOvqHtyZ+KNDCbeu950KxoHV62iTOo4n8Hsgw0QaGF6fAPDLjf5Bk4tm1h9QrGvsEWM49Fb57WcC70tCka;
Message-ID: <f3b1b41cec770d7cca99849e22fa9946.squirrel@xenotime.net>
In-Reply-To: <1305966108-13399-2-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
    <1305966108-13399-2-git-send-email-jim.cromie@gmail.com>
Date: Sun, 22 May 2011 19:16:17 -0700
Subject: Re: [PATCH 1/3] do collectcfiles work in perl itself, eschew shell
 pipeline
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Jim Cromie" <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "Jim Cromie" <jim.cromie@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 1:21 am, Jim Cromie wrote:

>  sub collectcfiles {
> -    my @file
> -	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko$/.mod.c/`;
> +    my @file;
> +    while (<.tmp_versions/*.mod>) {
> +	open my $fh, '<', $_ or die "cant open $_: $!\n";

Use either "can't" or "cannot".  "cant" is a different word.

> +	push (@file,
> +	      grep s/\.ko/.mod.c/,	# change the suffix
> +	      grep m/.+\.ko/,		# find the .ko path
> +	      <$fh>);			# lines in opened file
> +    }
>      chomp @file;
>      return @file;
>  }


-- 
~Randy

