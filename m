Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1JEUcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:32:36 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55911 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab1JEUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:32:35 -0400
Message-ID: <4E8CBEDC.4010502@linux.vnet.ibm.com>
Date: Thu, 06 Oct 2011 02:02:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Thomas Tuttle <ttuttle@chromium.org>
CC: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] ramoops: scripts/ramoops.c for extracting oopses
References: <20111005182503.GA6142@google.com>
In-Reply-To: <20111005182503.GA6142@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/05/2011 11:55 PM, Thomas Tuttle wrote:
> +static int print_records(int record)
> +{
> +	unsigned long mem_address, mem_size, record_size, num_records;
> +	FILE *mem;
> +	int i;
> +	int ret = 0;
> +
> +	read_long(RAMOOPS_PARAM "mem_address", &mem_address);
> +	read_long(RAMOOPS_PARAM "mem_size",    &mem_size);
> +	read_long(RAMOOPS_PARAM "record_size", &record_size);
> +	num_records = mem_size / record_size;
> +
> +	if (record != REC_LIST &&
> +	    (record < 0 || (unsigned long)record >= num_records)) {
> +		fprintf(stderr, "%s: record number %d out of range [0, %ld)\n",
> +			progn, record, num_records);
> +		return 1;
> +	}
> +
> +	buf = malloc(record_size);

Since buf is not declared, this fails program compilation.

> +	if (!buf) {
> +		fprintf(stderr, "%s: failed to allocate record buffer\n",
> +			progn);
> +		return 1;
> +	}
> +

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
