Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1GLQeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:34:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab1GLQeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:34:11 -0400
Message-ID: <4E1C7781.5080406@suse.cz>
Date: Tue, 12 Jul 2011 18:34:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
References: <20110707171627.4f15035e.akpm@linux-foundation.org>	<4E1C5487.9030405@suse.cz> <20110712090156.c051d864.akpm@linux-foundation.org>
In-Reply-To: <20110712090156.c051d864.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.7.2011 18:01, Andrew Morton wrote:
> On Tue, 12 Jul 2011 16:04:55 +0200 Michal Marek<mmarek@suse.cz>  wrote:
>> Nevertheless, these errors are pretty harmless, the prototypes do not
>> break parsing the header when compiling userspace programs.
>
> Well, it's a bit harmful - someone did an exit(non-zero) and `make'
> terminates the build with a build error.

That's strange, scripts/headers_check.pl only exits with non-zero if it 
finds that a included header file is not exported:

			printf STDERR "$filename:$lineno: included file '$inc' is not 
exported\n";
			$ret = 1;

in all other cases the $ret assignment is commented out:

		# Warn until headers are all fixed
		#$ret = 1;

and it works for me on both v3.0-rc7 and next-20110707.

Michal
