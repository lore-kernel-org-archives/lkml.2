Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0CUPcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 11:32:10 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:58583 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0CUPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 11:32:09 -0400
X-SENDER-IP: [83.226.249.129]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjozABvYpUtT4vmBPGdsb2JhbACBO4QslV8BAQEBN7hXhH0E
X-IronPort-AV: E=Sophos;i="4.51,283,1267398000"; 
   d="scan'208";a="53835771"
Message-ID: <4BA63BCE.9050802@coyote.org>
Date: Sun, 21 Mar 2010 16:31:26 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, gregkh@suse.de, greg@kroah.com,
       penberg@cs.helsinki.fi, pavel@ucw.cz, harvey.harrison@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: strip_whitespace.pl
References: <1269098051-6594-1-git-send-email-lindley@coyote.org> <20100320162426.GB28881@bicker> <4BA5204C.9050208@coyote.org> <20100321105541.GK5331@bicker> <20100321110758.GL5331@bicker>
In-Reply-To: <20100321110758.GL5331@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes this seems like a good tool to use.
I will sure use it in the future..

/Lars


On 2010-03-21 12:07, Dan Carpenter wrote:
> On Sun, Mar 21, 2010 at 01:55:42PM +0300, Dan Carpenter wrote:
>> I've written a new script called strip_whitespace.pl (included).
>>
>> One bug is that, if you split or unsplit a string literal that
>> confuses it.  Otherwise it seems to work.
>>
>> strip_whitespace.pl drivers/staging/winbond/reg.c > before
>> apply patch
>> strip_whitespace.pl drivers/staging/winbond/reg.c > after
>>
>> `diff before after`.  If they are the same then resend the patch.
> 
> On further reflection your new patch looks fine, if you combine the two.  
> But next time could you use my script?
> 
> Acked-by:  Dan Carpenter <error27@gmail.com>
> 
> regards,
> dan carpenter
> 
>>
>> regards,
>> dan carpenter
>>
>> #!/usr/bin/perl
>>
>> use strict;
>>
>> my $file = shift();
>> open FILE, "<$file";
>> my $txt = do { local $/;  <FILE> };
>>
>> # strip C99 comments
>> $txt =~ s/\/\/.*//g;
>> # strip newlines
>> $txt =~ s/\n//g;
>> # strip remaining comments
>> $txt =~ s/\/\*.*?\*\///g;
>> # strip tabs
>> $txt =~ s/\t//g;
>> # strip spaces
>> $txt =~ s/ //g;
>> # add newlines again
>> $txt =~ s/;/;\n/g;
>>
>> print "$txt\n";
> 
