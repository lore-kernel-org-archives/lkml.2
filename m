Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3AFLmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:42:10 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:53842 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab3AFLmH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:42:07 -0500
References: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com> <20130106035809.GG4674@truffula.fritz.box>
In-Reply-To: <20130106035809.GG4674@truffula.fritz.box>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com>
Cc: Jon Loeliger <jdl@jdl.com>, Matt Porter <mporter@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
X-Mailer: iPhone Mail (10A523)
From: Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: Fix test relying in wrong behavior of is_printable
Date: Sun, 6 Jan 2013 13:41:56 +0200
To: David Gibson <david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

Από το iPhone μου

6 Ιαν 2013, 5:58, ο/η David Gibson <david@gibson.dropbear.id.au> έγραψε:

> On Fri, Jan 04, 2013 at 09:16:08PM +0200, Pantelis Antoniou wrote:
>> After fixing the is_printable bug the test suite fails.
>> Fix it with this patch
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> Rather than just removing the test, it would be better to still run it
> using an explicit -t bi to force the byte output.

Perhaps it wasn't exactly clear in the patch. The old test case output is commented out but there is test case output for the new patch. 

So the test is not removed. 


Regards

-- Pantelis
> 
>> ---
>> tests/run_tests.sh | 5 ++---
>> 1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tests/run_tests.sh b/tests/run_tests.sh
>> index dd7f217..43279c9 100755
>> --- a/tests/run_tests.sh
>> +++ b/tests/run_tests.sh
>> @@ -498,9 +498,8 @@ fdtget_tests () {
>> 
>>     # run_fdtget_test <expected-result> [<flags>] <file> <node> <property>
>>     run_fdtget_test "MyBoardName" $dtb / model
>> -    run_fdtget_test "77 121 66 111 \
>> -97 114 100 78 97 109 101 0 77 121 66 111 97 114 100 70 97 109 105 \
>> -108 121 78 97 109 101 0" $dtb / compatible
>> +    # run_fdtget_test "77 121 66 111 97 114 100 78 97 109 101 0 77 121 66 111 97 114 100 70 97 109 105 108 121 78 97 109 101 0" $dtb / compatible
>> +    run_fdtget_test "MyBoardName MyBoardFamilyName" $dtb / compatible
>>     run_fdtget_test "MyBoardName MyBoardFamilyName" -t s $dtb / compatible
>>     run_fdtget_test 32768 $dtb /cpus/PowerPC,970@1 d-cache-size
>>     run_fdtget_test 8000 -tx $dtb /cpus/PowerPC,970@1 d-cache-size
> 
> -- 
> David Gibson            | I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au    | minimalist, thank you.  NOT _the_ _other_
>                | _way_ _around_!
> http://www.ozlabs.org/~dgibson
