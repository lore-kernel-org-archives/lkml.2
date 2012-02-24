Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2BXSWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:22:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:35359 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab2BXSWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:22:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110468241"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andrei.emeltchenko.news@gmail.com" 
	<andrei.emeltchenko.news@gmail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Topic: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Index: AQHM8Nu9391LFUTMFEuqxrbxHQK9JZZH4RQAgADIE4D//30WsIAAiTiA//98R1CAAjNUAIACAOSw
Date: Fri, 24 Feb 2012 18:22:20 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1842A1D36@ORSMSX102.amr.corp.intel.com>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
	 <1329857959.5143.11.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
	 <1329874581.5143.22.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>
	 <1329875935.5143.24.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B98A@ORSMSX102.amr.corp.intel.com>
 <1329968622.5143.46.camel@joe2Laptop>
In-Reply-To: <1329968622.5143.46.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1OIMoF2008039

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Wednesday, February 22, 2012 7:44 PM
> To: Allan, Bruce W
> Cc: David Miller; Andy Whitcroft; Andrew Morton;
> andrei.emeltchenko.news@gmail.com; linville@tuxdriver.com; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
> 
> Hi Bruce. (yay, I got your name right)
> 
> Thanks.
> 
> How about testing this?
> 
> It allows all spaces or appropriate tabs for indentation,
> and I believe it works OK.
> 
> ---
>  scripts/checkpatch.pl |   65
> +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 63 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 89d24b3..7a0514b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -330,10 +330,11 @@ sub build_types {
>  }
>  build_types();
> 
> -our $match_balanced_parentheses = qr/(\((?:[^\(\)]+|(-1))*\))/;
> +our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
> +our $lval_parens = qr/(\((?:[^\(\)]+|(-1))*\))/;
> 
>  our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
> -our $LvalOrFunc	=
> qr{($Lval)\s*($match_balanced_parentheses{0,1})\s*};
> +our $LvalOrFunc	= qr{($Lval)\s*($lval_parens{0,1})\s*};
>  our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
> 
>  sub deparenthesize {
> @@ -1330,6 +1331,36 @@ sub check_absolute_file {
>  	}
>  }
> 
> +sub pos_last_openparen {
> +	my ($line) = @_;
> +
> +	my $pos = 0;
> +
> +	my $opens = $line =~ tr/\(/\(/;
> +	my $closes = $line =~ tr/\)/\)/;
> +
> +	my $last_openparen = 0;
> +
> +	if (($opens == 0) || ($closes >= $opens)) {
> +		return -1;
> +	}
> +
> +	my $len = length($line);
> +
> +	for ($pos = 0; $pos < $len; $pos++) {
> +	    my $string = substr($line, $pos);
> +	    if ($string =~ /^($FuncArg|$balanced_parens)/) {
> +		    $pos += length($1);
> +	    }
> +
> +	    if (substr($line, $pos, 1) eq '(') {
> +		$last_openparen = $pos;
> +	    }
> +	}
> +
> +	return $last_openparen + 1;
> +}
> +
>  sub process {
>  	my $filename = shift;
> 
> @@ -1783,6 +1814,36 @@ sub process {
>  			     "please, no space before tabs\n" . $herevet);
>  		}
> 
> +# check for && or || at the start of a line
> +		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
> +			CHK("LOGICAL_CONTINUATIONS",
> +			    "Logical continuations should be on the previous
> line\n" . $hereprev);
> +		}
> +
> +# check multi-line statement indentation matches previous line
> +		if ($prevline =~ /^\+(\t*)(if
> \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
> +			$prevline =~ /^\+(\t*)(.*)$/;
> +			my $oldindent = $1;
> +			my $rest = $2;
> +
> +			my $pos = pos_last_openparen($rest);
> +			if ($pos >= 0) {
> +				$line =~ /^\+([ \t]*)/;
> +				my $newindent = $1;
> +
> +				my $goodtabindent = $oldindent .
> +					"\t" x ($pos / 8) .
> +					" "  x ($pos % 8);
> +				my $goodspaceindent = $oldindent . " "  x
> $pos;
> +
> +				if ($newindent ne $goodtabindent &&
> +				    $newindent ne $goodspaceindent) {
> +					CHK("PARENTHESIS_ALIGNMENT",
> +					    "Alignment should match open
> parenthesis\n" . $hereprev);
> +				}
> +			}
> +		}
> +
>  # check for spaces at the beginning of a line.
>  # Exceptions:
>  #  1) within comments
> 

This latest version is much better.  It does not report false positives in the
limited code I checked it against.

Bruce.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
