Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2HVNbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:31:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60453 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HVNbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:31:40 -0400
Date: Wed, 22 Aug 2012 15:31:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120822133136.GC6899@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>,
	linux-kernel@vger.kernel.org
References: <20120820173213.GD4060@x1.osrc.amd.com>
 <20120822041825.12398.99246.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120822041825.12398.99246.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 07:35:12AM +0300, Jussi Kivilinna wrote:
> Looks that encryption lost ~0.4% while decryption gained ~1.8%.
> 
> For 256 byte test, it's still slightly slower than twofish-3way (~3%). For 1k
> and 8k tests, it's ~5% faster.
> 
> Here's very last test-patch, testing different ordering of fpu<->cpu reg
> instructions at few places.

Hehe,

I don't mind testing patches, no worries there. Here are the results
this time, doesn't look better than the last run, AFAICT.

[  133.952723] 
[  133.952723] testing speed of async ecb(twofish) encryption
[  133.961946] test 0 (128 bit key, 16 byte blocks): 4768513 operations in 1 seconds (76296208 bytes)
[  134.968388] test 1 (128 bit key, 64 byte blocks): 2033479 operations in 1 seconds (130142656 bytes)
[  135.975070] test 2 (128 bit key, 256 byte blocks): 604754 operations in 1 seconds (154817024 bytes)
[  136.981570] test 3 (128 bit key, 1024 byte blocks): 169578 operations in 1 seconds (173647872 bytes)
[  137.988191] test 4 (128 bit key, 8192 byte blocks): 21847 operations in 1 seconds (178970624 bytes)
[  138.994735] test 5 (192 bit key, 16 byte blocks): 4777481 operations in 1 seconds (76439696 bytes)
[  140.001382] test 6 (192 bit key, 64 byte blocks): 2035352 operations in 1 seconds (130262528 bytes)
[  141.008038] test 7 (192 bit key, 256 byte blocks): 603240 operations in 1 seconds (154429440 bytes)
[  142.014591] test 8 (192 bit key, 1024 byte blocks): 169266 operations in 1 seconds (173328384 bytes)
[  143.021169] test 9 (192 bit key, 8192 byte blocks): 21610 operations in 1 seconds (177029120 bytes)
[  144.027703] test 10 (256 bit key, 16 byte blocks): 4798051 operations in 1 seconds (76768816 bytes)
[  145.034341] test 11 (256 bit key, 64 byte blocks): 2036766 operations in 1 seconds (130353024 bytes)
[  146.041015] test 12 (256 bit key, 256 byte blocks): 604216 operations in 1 seconds (154679296 bytes)
[  147.047523] test 13 (256 bit key, 1024 byte blocks): 169594 operations in 1 seconds (173664256 bytes)
[  148.054120] test 14 (256 bit key, 8192 byte blocks): 21889 operations in 1 seconds (179314688 bytes)
[  149.060657] 
[  149.060657] testing speed of async ecb(twofish) decryption
[  149.069830] test 0 (128 bit key, 16 byte blocks): 4890581 operations in 1 seconds (78249296 bytes)
[  150.075322] test 1 (128 bit key, 64 byte blocks): 2006891 operations in 1 seconds (128441024 bytes)
[  151.081994] test 2 (128 bit key, 256 byte blocks): 586650 operations in 1 seconds (150182400 bytes)
[  152.088522] test 3 (128 bit key, 1024 byte blocks): 164734 operations in 1 seconds (168687616 bytes)
[  153.091153] test 4 (128 bit key, 8192 byte blocks): 21111 operations in 1 seconds (172941312 bytes)
[  154.097687] test 5 (192 bit key, 16 byte blocks): 4911365 operations in 1 seconds (78581840 bytes)
[  155.104371] test 6 (192 bit key, 64 byte blocks): 2025363 operations in 1 seconds (129623232 bytes)
[  156.111154] test 7 (192 bit key, 256 byte blocks): 591229 operations in 1 seconds (151354624 bytes)
[  157.117723] test 8 (192 bit key, 1024 byte blocks): 164381 operations in 1 seconds (168326144 bytes)
[  158.124336] test 9 (192 bit key, 8192 byte blocks): 20714 operations in 1 seconds (169689088 bytes)
[  159.130724] test 10 (256 bit key, 16 byte blocks): 4931938 operations in 1 seconds (78911008 bytes)
[  160.137379] test 11 (256 bit key, 64 byte blocks): 2029741 operations in 1 seconds (129903424 bytes)
[  161.144078] test 12 (256 bit key, 256 byte blocks): 589340 operations in 1 seconds (150871040 bytes)
[  162.150580] test 13 (256 bit key, 1024 byte blocks): 164484 operations in 1 seconds (168431616 bytes)
[  163.157174] test 14 (256 bit key, 8192 byte blocks): 21116 operations in 1 seconds (172982272 bytes)
[  164.163694] 
[  164.163694] testing speed of async cbc(twofish) encryption
[  164.177772] test 0 (128 bit key, 16 byte blocks): 5197069 operations in 1 seconds (83153104 bytes)
[  165.186414] test 1 (128 bit key, 64 byte blocks): 1912975 operations in 1 seconds (122430400 bytes)
[  166.193078] test 2 (128 bit key, 256 byte blocks): 540464 operations in 1 seconds (138358784 bytes)
[  167.199587] test 3 (128 bit key, 1024 byte blocks): 140709 operations in 1 seconds (144086016 bytes)
[  168.206209] test 4 (128 bit key, 8192 byte blocks): 17747 operations in 1 seconds (145383424 bytes)
[  169.212768] test 5 (192 bit key, 16 byte blocks): 5184004 operations in 1 seconds (82944064 bytes)
[  170.219372] test 6 (192 bit key, 64 byte blocks): 1913377 operations in 1 seconds (122456128 bytes)
[  171.226028] test 7 (192 bit key, 256 byte blocks): 541385 operations in 1 seconds (138594560 bytes)
[  172.232538] test 8 (192 bit key, 1024 byte blocks): 140867 operations in 1 seconds (144247808 bytes)
[  173.239280] test 9 (192 bit key, 8192 byte blocks): 17642 operations in 1 seconds (144523264 bytes)
[  174.245667] test 10 (256 bit key, 16 byte blocks): 5193804 operations in 1 seconds (83100864 bytes)
[  175.252331] test 11 (256 bit key, 64 byte blocks): 1907560 operations in 1 seconds (122083840 bytes)
[  176.259013] test 12 (256 bit key, 256 byte blocks): 540773 operations in 1 seconds (138437888 bytes)
[  177.265669] test 13 (256 bit key, 1024 byte blocks): 140699 operations in 1 seconds (144075776 bytes)
[  178.272126] test 14 (256 bit key, 8192 byte blocks): 17744 operations in 1 seconds (145358848 bytes)
[  179.278698] 
[  179.278698] testing speed of async cbc(twofish) decryption
[  179.288016] test 0 (128 bit key, 16 byte blocks): 4877381 operations in 1 seconds (78038096 bytes)
[  180.293323] test 1 (128 bit key, 64 byte blocks): 1947911 operations in 1 seconds (124666304 bytes)
[  181.299994] test 2 (128 bit key, 256 byte blocks): 577589 operations in 1 seconds (147862784 bytes)
[  182.306512] test 3 (128 bit key, 1024 byte blocks): 159665 operations in 1 seconds (163496960 bytes)
[  183.313115] test 4 (128 bit key, 8192 byte blocks): 20403 operations in 1 seconds (167141376 bytes)
[  184.319652] test 5 (192 bit key, 16 byte blocks): 4885336 operations in 1 seconds (78165376 bytes)
[  185.326307] test 6 (192 bit key, 64 byte blocks): 1939707 operations in 1 seconds (124141248 bytes)
[  186.332972] test 7 (192 bit key, 256 byte blocks): 574612 operations in 1 seconds (147100672 bytes)
[  187.339496] test 8 (192 bit key, 1024 byte blocks): 158410 operations in 1 seconds (162211840 bytes)
[  188.346102] test 9 (192 bit key, 8192 byte blocks): 19940 operations in 1 seconds (163348480 bytes)
[  189.352646] test 10 (256 bit key, 16 byte blocks): 4897969 operations in 1 seconds (78367504 bytes)
[  190.359301] test 11 (256 bit key, 64 byte blocks): 1945680 operations in 1 seconds (124523520 bytes)
[  191.365965] test 12 (256 bit key, 256 byte blocks): 578743 operations in 1 seconds (148158208 bytes)
[  192.372475] test 13 (256 bit key, 1024 byte blocks): 159732 operations in 1 seconds (163565568 bytes)
[  193.379068] test 14 (256 bit key, 8192 byte blocks): 20421 operations in 1 seconds (167288832 bytes)
[  194.385621] 
[  194.385621] testing speed of async ctr(twofish) encryption
[  194.399652] test 0 (128 bit key, 16 byte blocks): 4576370 operations in 1 seconds (73221920 bytes)
[  195.408279] test 1 (128 bit key, 64 byte blocks): 1945671 operations in 1 seconds (124522944 bytes)
[  196.414951] test 2 (128 bit key, 256 byte blocks): 585959 operations in 1 seconds (150005504 bytes)
[  197.421462] test 3 (128 bit key, 1024 byte blocks): 159292 operations in 1 seconds (163115008 bytes)
[  198.428072] test 4 (128 bit key, 8192 byte blocks): 20497 operations in 1 seconds (167911424 bytes)
[  199.434598] test 5 (192 bit key, 16 byte blocks): 4682261 operations in 1 seconds (74916176 bytes)
[  200.441262] test 6 (192 bit key, 64 byte blocks): 1959838 operations in 1 seconds (125429632 bytes)
[  201.447927] test 7 (192 bit key, 256 byte blocks): 571085 operations in 1 seconds (146197760 bytes)
[  202.454445] test 8 (192 bit key, 1024 byte blocks): 158933 operations in 1 seconds (162747392 bytes)
[  203.461056] test 9 (192 bit key, 8192 byte blocks): 20462 operations in 1 seconds (167624704 bytes)
[  204.467565] test 10 (256 bit key, 16 byte blocks): 4373557 operations in 1 seconds (69976912 bytes)
[  205.474257] test 11 (256 bit key, 64 byte blocks): 1949469 operations in 1 seconds (124766016 bytes)
[  206.480921] test 12 (256 bit key, 256 byte blocks): 576799 operations in 1 seconds (147660544 bytes)
[  207.487430] test 13 (256 bit key, 1024 byte blocks): 159786 operations in 1 seconds (163620864 bytes)
[  208.494025] test 14 (256 bit key, 8192 byte blocks): 20514 operations in 1 seconds (168050688 bytes)
[  209.500569] 
[  209.500569] testing speed of async ctr(twofish) decryption
[  209.509891] test 0 (128 bit key, 16 byte blocks): 4573902 operations in 1 seconds (73182432 bytes)
[  210.515256] test 1 (128 bit key, 64 byte blocks): 1950356 operations in 1 seconds (124822784 bytes)
[  211.521921] test 2 (128 bit key, 256 byte blocks): 576961 operations in 1 seconds (147702016 bytes)
[  212.528577] test 3 (128 bit key, 1024 byte blocks): 159763 operations in 1 seconds (163597312 bytes)
[  213.535069] test 4 (128 bit key, 8192 byte blocks): 20487 operations in 1 seconds (167829504 bytes)
[  214.541717] test 5 (192 bit key, 16 byte blocks): 4657220 operations in 1 seconds (74515520 bytes)
[  215.548250] test 6 (192 bit key, 64 byte blocks): 1965789 operations in 1 seconds (125810496 bytes)
[  216.554907] test 7 (192 bit key, 256 byte blocks): 573294 operations in 1 seconds (146763264 bytes)
[  217.561432] test 8 (192 bit key, 1024 byte blocks): 159180 operations in 1 seconds (163000320 bytes)
[  218.568037] test 9 (192 bit key, 8192 byte blocks): 20324 operations in 1 seconds (166494208 bytes)
[  219.574719] test 10 (256 bit key, 16 byte blocks): 4453463 operations in 1 seconds (71255408 bytes)
[  220.581245] test 11 (256 bit key, 64 byte blocks): 1965129 operations in 1 seconds (125768256 bytes)
[  221.587910] test 12 (256 bit key, 256 byte blocks): 576236 operations in 1 seconds (147516416 bytes)
[  222.594408] test 13 (256 bit key, 1024 byte blocks): 159425 operations in 1 seconds (163251200 bytes)
[  223.601169] test 14 (256 bit key, 8192 byte blocks): 20489 operations in 1 seconds (167845888 bytes)
[  224.607566] 
[  224.607566] testing speed of async lrw(twofish) encryption
[  224.622145] test 0 (256 bit key, 16 byte blocks): 3501782 operations in 1 seconds (56028512 bytes)
[  225.630224] test 1 (256 bit key, 64 byte blocks): 1613072 operations in 1 seconds (103236608 bytes)
[  226.636896] test 2 (256 bit key, 256 byte blocks): 497185 operations in 1 seconds (127279360 bytes)
[  227.643415] test 3 (256 bit key, 1024 byte blocks): 138762 operations in 1 seconds (142092288 bytes)
[  228.650027] test 4 (256 bit key, 8192 byte blocks): 17841 operations in 1 seconds (146153472 bytes)
[  229.656571] test 5 (320 bit key, 16 byte blocks): 3569802 operations in 1 seconds (57116832 bytes)
[  230.663357] test 6 (320 bit key, 64 byte blocks): 1619243 operations in 1 seconds (103631552 bytes)
[  231.669882] test 7 (320 bit key, 256 byte blocks): 497649 operations in 1 seconds (127398144 bytes)
[  232.676382] test 8 (320 bit key, 1024 byte blocks): 138425 operations in 1 seconds (141747200 bytes)
[  233.682986] test 9 (320 bit key, 8192 byte blocks): 17621 operations in 1 seconds (144351232 bytes)
[  234.689512] test 10 (384 bit key, 16 byte blocks): 3572115 operations in 1 seconds (57153840 bytes)
[  235.696175] test 11 (384 bit key, 64 byte blocks): 1632166 operations in 1 seconds (104458624 bytes)
[  236.702850] test 12 (384 bit key, 256 byte blocks): 496593 operations in 1 seconds (127127808 bytes)
[  237.709348] test 13 (384 bit key, 1024 byte blocks): 138736 operations in 1 seconds (142065664 bytes)
[  238.715953] test 14 (384 bit key, 8192 byte blocks): 17864 operations in 1 seconds (146341888 bytes)
[  239.722482] 
[  239.722482] testing speed of async lrw(twofish) decryption
[  239.732092] test 0 (256 bit key, 16 byte blocks): 3369646 operations in 1 seconds (53914336 bytes)
[  240.737175] test 1 (256 bit key, 64 byte blocks): 1595683 operations in 1 seconds (102123712 bytes)
[  241.743969] test 2 (256 bit key, 256 byte blocks): 481201 operations in 1 seconds (123187456 bytes)
[  242.750356] test 3 (256 bit key, 1024 byte blocks): 134713 operations in 1 seconds (137946112 bytes)
[  243.756963] test 4 (256 bit key, 8192 byte blocks): 17342 operations in 1 seconds (142065664 bytes)
[  244.763479] test 5 (320 bit key, 16 byte blocks): 3519317 operations in 1 seconds (56309072 bytes)
[  245.770159] test 6 (320 bit key, 64 byte blocks): 1589175 operations in 1 seconds (101707200 bytes)
[  246.776815] test 7 (320 bit key, 256 byte blocks): 480032 operations in 1 seconds (122888192 bytes)
[  247.783341] test 8 (320 bit key, 1024 byte blocks): 134196 operations in 1 seconds (137416704 bytes)
[  248.789955] test 9 (320 bit key, 8192 byte blocks): 16979 operations in 1 seconds (139091968 bytes)
[  249.796480] test 10 (384 bit key, 16 byte blocks): 3569030 operations in 1 seconds (57104480 bytes)
[  250.803154] test 11 (384 bit key, 64 byte blocks): 1598999 operations in 1 seconds (102335936 bytes)
[  251.809809] test 12 (384 bit key, 256 byte blocks): 484369 operations in 1 seconds (123998464 bytes)
[  252.816328] test 13 (384 bit key, 1024 byte blocks): 134804 operations in 1 seconds (138039296 bytes)
[  253.822922] test 14 (384 bit key, 8192 byte blocks): 17314 operations in 1 seconds (141836288 bytes)
[  254.829487] 
[  254.829487] testing speed of async xts(twofish) encryption
[  254.843608] test 0 (256 bit key, 16 byte blocks): 3109395 operations in 1 seconds (49750320 bytes)
[  255.852126] test 1 (256 bit key, 64 byte blocks): 1579951 operations in 1 seconds (101116864 bytes)
[  256.858797] test 2 (256 bit key, 256 byte blocks): 504014 operations in 1 seconds (129027584 bytes)
[  257.865306] test 3 (256 bit key, 1024 byte blocks): 147066 operations in 1 seconds (150595584 bytes)
[  258.871918] test 4 (256 bit key, 8192 byte blocks): 19266 operations in 1 seconds (157827072 bytes)
[  259.878445] test 5 (384 bit key, 16 byte blocks): 3099540 operations in 1 seconds (49592640 bytes)
[  260.885109] test 6 (384 bit key, 64 byte blocks): 1579599 operations in 1 seconds (101094336 bytes)
[  261.891774] test 7 (384 bit key, 256 byte blocks): 504289 operations in 1 seconds (129097984 bytes)
[  262.898292] test 8 (384 bit key, 1024 byte blocks): 147102 operations in 1 seconds (150632448 bytes)
[  263.904904] test 9 (384 bit key, 8192 byte blocks): 19264 operations in 1 seconds (157810688 bytes)
[  264.911422] test 10 (512 bit key, 16 byte blocks): 3171752 operations in 1 seconds (50748032 bytes)
[  265.918104] test 11 (512 bit key, 64 byte blocks): 1588640 operations in 1 seconds (101672960 bytes)
[  266.924772] test 12 (512 bit key, 256 byte blocks): 505971 operations in 1 seconds (129528576 bytes)
[  267.931267] test 13 (512 bit key, 1024 byte blocks): 147292 operations in 1 seconds (150827008 bytes)
[  268.937863] test 14 (512 bit key, 8192 byte blocks): 19263 operations in 1 seconds (157802496 bytes)
[  269.944426] 
[  269.944426] testing speed of async xts(twofish) decryption
[  269.953737] test 0 (256 bit key, 16 byte blocks): 3097600 operations in 1 seconds (49561600 bytes)
[  270.959104] test 1 (256 bit key, 64 byte blocks): 1552959 operations in 1 seconds (99389376 bytes)
[  271.965690] test 2 (256 bit key, 256 byte blocks): 506885 operations in 1 seconds (129762560 bytes)
[  272.972285] test 3 (256 bit key, 1024 byte blocks): 144134 operations in 1 seconds (147593216 bytes)
[  273.978907] test 4 (256 bit key, 8192 byte blocks): 18638 operations in 1 seconds (152682496 bytes)
[  274.985432] test 5 (384 bit key, 16 byte blocks): 3101878 operations in 1 seconds (49630048 bytes)
[  275.992098] test 6 (384 bit key, 64 byte blocks): 1552884 operations in 1 seconds (99384576 bytes)
[  276.998658] test 7 (384 bit key, 256 byte blocks): 507621 operations in 1 seconds (129950976 bytes)
[  278.005271] test 8 (384 bit key, 1024 byte blocks): 144218 operations in 1 seconds (147679232 bytes)
[  279.011884] test 9 (384 bit key, 8192 byte blocks): 18622 operations in 1 seconds (152551424 bytes)
[  280.018419] test 10 (512 bit key, 16 byte blocks): 3185817 operations in 1 seconds (50973072 bytes)
[  281.025090] test 11 (512 bit key, 64 byte blocks): 1562195 operations in 1 seconds (99980480 bytes)
[  282.031661] test 12 (512 bit key, 256 byte blocks): 507517 operations in 1 seconds (129924352 bytes)
[  283.038255] test 13 (512 bit key, 1024 byte blocks): 144199 operations in 1 seconds (147659776 bytes)
[  284.044860] test 14 (512 bit key, 8192 byte blocks): 18609 operations in 1 seconds (152444928 bytes)

-- 
Regards/Gruss,
Boris.
