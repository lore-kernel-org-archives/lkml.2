Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2IRUk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:40:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41911 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab2IRUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:40:56 -0400
Message-ID: <5058DC54.1030700@kernel.org>
Date: Tue, 18 Sep 2012 21:40:52 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the staging tree
References: <20120912160719.4377f041ac76ddfa13be7df1@canb.auug.org.au>
In-Reply-To: <20120912160719.4377f041ac76ddfa13be7df1@canb.auug.org.au>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/12/2012 07:07 AM, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/hid/hid-sensor-hub.c: In function 'sensor_hub_probe': drivers/hid/hid-sensor-hub.c:599:3: error: too few
> arguments to function 'mfd_add_devices'
> 
> Caused by commit 401ca24fb34a ("HID: sensors: introduce sensor framework") interacting with commit 6607bad3d763
> ("mfd: core: Push irqdomain mapping out into devices") from the mfd tree.
> 
> I have added the following merge fix patch and can carry it as necessary (no action is required).

Just as a heads up, this issue has now bitten us directly in the staging-next
tree as the mfd change is now in Linus' tree and that was merged into
staging-next at rc6.

I'll queue up Stephen's patch but might be a few days before I send the pull
containing it to Greg.

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au> Date: Wed, 12 Sep 2012 16:03:55 +1000 Subject: [PATCH] HID: sensors:
> fix up for mfd_add_devices() API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au> --- drivers/hid/hid-sensor-hub.c |    2 +- 1 file changed, 1
> insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c index 34a35ba..4ac759c 100644 ---
> a/drivers/hid/hid-sensor-hub.c +++ b/drivers/hid/hid-sensor-hub.c @@ -596,7 +596,7 @@ static int
> sensor_hub_probe(struct hid_device *hdev, } } ret = mfd_add_devices(&hdev->dev, 0, sd->hid_sensor_hub_client_devs, 
> -		sd->hid_sensor_client_cnt, NULL, 0); +		sd->hid_sensor_client_cnt, NULL, 0, NULL); if (ret < 0) goto
> err_free_names;
> 
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQWNxTAAoJEFSFNJnE9BaInz4QALIn+9yuYA/I+W7dl8miwb6T
QN+tEpTO7gdgBkLt6AWC4apjmN1Lk4FXu2qS0U8evKwtCGN+v0IdDjjWq3qloAF+
I7zdthLnjstOqFIv0wr3dmf2ZiURv7oERdiBtp8h92j6NZHDPAHnoF7xRvn08Tsc
EWOsUKURIr245hd0ApTfuZdor696SXx8HVCYjDDIPXpP/7yY/yE07ID+QESRwhxh
znFiGyLvPw3zTQYE2IqRPAMdKQrJbX7wOLY7bAMKniwI43jEU6HHcZRCGSDOHaPq
4Nxc6WrqqAyWD3zDqurQvM3OgIgL/QC4b88WuUhcyWGZhumK4ivW0evCq8BM10jn
gJqJnAu/JX8Q/JLMl0z0sPFjmSdfkWmywz0zOQEOPvwoXNENdT5kalYA51sP9vqe
bCOnGMATrDb+76o4RxkOnwp2CAMoDrDqeSqtH1FM2UJPFZhB9ly0eQvmh1zmeJlV
FD4iB8tjJnHIUX3ZW12/ylP6vpYSZnoWDH0kSVSfNNJXWYqoaWKXODxsiaMJRwX3
tFGzR/KrRKkKwowV4VAWyVmO+U7jne0cV3VvWX4CHQRSsrzjAmX3mVm915rCLTkT
zAed3Svr/LjBeXY5IGU2gY4o4TPvyJwhBh9rRfmIYuLM6qE15itT5q7CQjFu/jrs
Apz5hKLeGuMepT1EokNb
=/JJX
-----END PGP SIGNATURE-----
